class BooksController < ApplicationController
  def index
    @books = Book
    unless params[:catid].nil?
      @books = @books.where(category_id: params[:catid])
    end
    unless params[:order].nil?
      case params[:order]
      when "newest"
        @books = @books.order('created_at DESC')
      when "popular"
        @books = @books.order('created_at ASC')
      when "lowprice"
        @books = @books.order('price ASC')
      when "highprice"
        @books = @books.order('price DESC')
      end
    end

    @books = @books.page(params[:page]).per(12)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def catalog
    redirect_to books_url, notice: t('mainpage.welcome1')+' '+t('mainpage.welcome2')
  end

  def show
    @book = Book.find(params[:id])
    @review = Review.new
    #pry
  end

  def new
    @book = Book.new
    @book.build_info_book
    @book.build_category
    @book.images.build
  end

  def create
    @book = Book.new(post_params)
    save_authors_to_book
    pry

    if @book.save
      redirect_to @book
    else
      render "new"
    end
  end

  def edit

    @book = Book.find(params[:id])
    #@category = @book.category || @book.build_category
    @info_book = @book.info_book || @book.build_info_book
    #@images = @book.images || @book.images.build
    #pry
    #@images = @book.images || @book.images.build
  end

  def update
    @book = Book.find(params[:id])
    #pry
    save_authors_to_book
    if @book.update_attributes(post_params)
      redirect_to @book
    else
      redirect_back(fallback_location: root_path)
    end
  end


  def destroy
    #pry
    @book = Book.find(params[:id]).destroy
    redirect_to books_url, notice: 'Book was deleted'
  end

  private
  #
    def post_params
      params.require(:book).permit(:name, :price, :short_desc, :category_id, :authors,
        images_attributes: [:image, :_destroy, :id],
        info_book_attributes: [:width, :height, :depth, :full_desc, :published, :materials, :quantity])
    end

    def review_params
      params.require(:book).permit( reviews_attributes: [:text, :title, :rating])
    end

    def category_params
      #.require(:category)
      params.permit(:name)
    end

    def save_authors_to_book
      @authors = []
      @exist_authors = []
      params[:authors].split(",").each do |item|
        item.strip!

        if(ex_author = Author.find_by(name: item))
          @exist_authors << ex_author
        else
          @authors << [name: item]
        end
        #a = Author.new
        #a.name = item

      end

      @book.authors.build @authors
      @book.authors += @exist_authors
    end

end
