module MicropostsHelper
  def upload_image(image, options = nil)
    options = { width: 200, height: 200 } if options.nil?
    res = Cloudinary::Uploader.upload(image, options)
    res['url']
  end
end
