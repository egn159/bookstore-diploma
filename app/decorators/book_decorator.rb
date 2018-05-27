class BookDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  def cover(type = :book_image)
    return Image::NOIMAGE_IMG if object.images.empty?
    object.images.first.image.url(type)
  end

  def authors_list
    object.authors.pluck(:name)&.join(', ') || ''
  end

  def sizes
    width = object.width || '-'
    height = object.height || '-'
    depth = object.depth || '-'

    "H: #{width} x W: #{height} x D: #{depth}"
  end

  def published_year
    object.published || '-'
  end

  def materials_list
    object.materials || '-'
  end

  def start_cutted_desc
    return object.full_desc unless more_desc?
    object.full_desc.truncate(Book::MAX_FULL_DESC_SHOW, omission: '')
  end

  def more_desc?
    return false if object.full_desc.nil?
    object.full_desc.length > Book::MAX_FULL_DESC_SHOW
  end

  def other_cutted_desc
    object.full_desc[Book::MAX_FULL_DESC_SHOW, object.full_desc.length - 1]
  end

  def more_images?
    object.images.size > 1
  end

  def other_images
    object.images[0, object.images.size - 1]
  end
end
