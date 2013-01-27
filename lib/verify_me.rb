# Load the helper files.
require 'verify_me/data_loader_web_based'
require 'verify_me/compose_overlay'
require 'RMagick'

module VerifyMe

  # The overlay calculations require the font "Helvetica Neue".
  FONT_HELVETICA_NEUE = File.expand_path("../verify_me/ttf/helveticaneue.ttf", __FILE__)

  class Verify
    # Instance variables:
    # - @screen_name       String: the twitter screen name.
    # - @sourceImage       Binary image data.
    # - @sourceImageFormat 
    # - @overlayPosition   Array of coordinates (x, y) to position the overlay.
    # - @dataloader

    def initialize(screen_name)
      @screen_name = screen_name

      # Attempt to load the data-loader handler.
      @dataloader = VerifyMe::DataLoaderWebBased.new(screen_name)
    end

    # Force a particular overlay position.
    # Coordinates is an array(x, y) of pixel positions of the overlay.
    def setOverlayPosition(coordinates)
      @overlayPosition = coordinates
    end

    # Force a particular background image.
    # binaryImageData should be the binary data of the image.
    def setSourceImage(binaryImageData)
      @sourceImage = binaryImageData
    end


    # Return binary image data.
    def getVerifiedImage
      # Ensure that @sourceImage and @overlayPosition is populated.
      populateMissingData

      # Add the overlay, and return the binary image data.
      return VerifyMe::composeOverlay(@sourceImage, @overlayPosition, @sourceImageFormat)
    end





    # Ensure any missing instance variables are populated.
    def populateMissingData
      # If the source image hasn't been provided, fetch it from twitter using
      # the provided screen name.
      if @sourceImage.nil?
        # Data-loader returns an array of the image data and the mime-type.
        imageData = @dataloader.getTwitterProfileBackgroundImage
        @sourceImage = imageData[0];
        @sourceImageFormat = imageData[1]
      end

      # If the overlay position hasn't been provided, calculate it using the
      # twitter screen name.
      if @overlayPosition.nil?
        full_name = @dataloader.getTwitterFullName
        @overlayPosition = VerifyMe::calculateOverlayPosition(full_name)
      end
    end

    public :setOverlayPosition, :setSourceImage, :getVerifiedImage
    protected :populateMissingData

  end



  # Returns the overlay position as an array (x, y)
  # where x and y are pixel co-ordinates.
  def self.calculateOverlayPosition(full_name)
    # X depends on the length of the HUMAN READABLE name.
    # Y is always 109.

    # Font rendering used by twitter:
    # font-family: "Helvetica Neue",​Arial,​sans-serif
    # font-size:    24px
    # font-weight:  Bold (i.e. 700)
    # line-height:  24px
    label = ::Magick::Draw.new
    label.font=FONT_HELVETICA_NEUE
    label.font_style=Magick::NormalStyle
    label.font_weight=Magick::BoldWeight
    label.pointsize = 24

    metrics = label.get_type_metrics(full_name)
    width = metrics.width

    x = 257 + (width / 2).floor

    # Fudge it to match empirical tests.
    x -= 6

    return [x, 109]
  end
end
