module VerifyMe

  # Define the path to the "Verified" logo image.
  VERIFIED_IMAGE = File.expand_path('../img/verified.png', __FILE__)

  # Returns binary image data.
  def self.composeOverlay(sourceImage, overlayPosition, baseImageFormat = 'png')
    # Load the base image from the input.
    base = Magick::ImageList.new
    base.from_blob(sourceImage)
    base.gravity = Magick::NorthWestGravity
    base.geometry = '+' + overlayPosition[0].to_s + '+' + overlayPosition[1].to_s

    # Load the "Verified" image from our local copy.
    verified = Magick::ImageList.new(VERIFIED_IMAGE)

    overlaid = base.composite_layers(verified, Magick::OverCompositeOp)

    # Match the incoming format.
    overlaid.format = baseImageFormat

    return overlaid.to_blob
  end
end
