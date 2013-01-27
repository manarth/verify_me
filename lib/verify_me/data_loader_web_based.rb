require 'uri'
require 'net/http'
require 'net/https'

module VerifyMe

  # Connect to twitter's web application to request data.
  class DataLoaderWebBased

    # Instance variables:
    # - @screen_name     String: the twitter screen name.
    # - @web_page        String: the HTML response from twitter.

    def initialize(screen_name)
      @screen_name = screen_name
      downloadTwitterWebPage
    end


    # Get the user's full name.
    def getTwitterFullName
      # Find a string in the HTML that looks like:
      # <h1 class="fullname"> Foo Bar </h1>
      # OR (verified)
      # <h1 class="fullname"> Foo Bar <a title="Verified profile" href="/help/verified" class="js-tooltip" data-placement="right"><i class="verified-large-border"></i></a> </h1>

      regex = /<h1 class="fullname">\s*([^<]+?)\s*(<a .+<\/a>)?\s*<\/h1>/m
      if @web_page.match(regex)
        full_name = @web_page.match(regex)[1]
      end
      return full_name
    end

    # Get the user's background image.
    def getTwitterProfileBackgroundImage
      # Look for the URL of the background image.
      if url=getTwitterProfileBackgroundImageUrl
        return fetchRemoteImage(url)
      else
        # Use the default image.
        default_image_filepath = File.expand_path("../img/grey_header_web.png", __FILE__)
        sourceImage = IO.read(default_image_filepath)
        return [sourceImage, 'png']
      end
    end





    # Get the background-profile image used by a user.
    def getTwitterProfileBackgroundImageUrl
      # Find a string in the HTML that looks like:
      # background-image: url(https://si0.twimg.com/profile_banners/44409004/1348689662/web);
      regex = '\sbackground-image: url\((https://si0.twimg.com/profile_banners/.+/web)\);'
      if @web_page.match(regex)
        return @web_page.match(regex)[1]
      end
      return nil
    end


    # Returns binary image data and mime-type.
    def fetchRemoteImage(url)
      uri = ::URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)

      # Switch to HTTPS if necessary.
      if uri.scheme == 'https'
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      # Make the HTTP request.
      response = http.request(Net::HTTP::Get.new(uri.request_uri))

      if response.code == "200" && response["Content-Type"].match(/^image\/(.+)$/)
        # Strip the "image/" prefix from the content-type.
        return response.body, response["Content-Type"].match(/^image\/(.+)$/)[1]
      end
    end


    # Download the twitter web page, store locally.
    def downloadTwitterWebPage
      twitterURL = 'https://twitter.com/' + @screen_name

      uri = ::URI.parse(twitterURL)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      # Make the HTTP request to Twitter.
      response = http.request(Net::HTTP::Get.new(uri.request_uri))

      # If it's not accepted, throw an exception.
      @web_page = response.body
    end

    public :getTwitterFullName, :getTwitterProfileBackgroundImage
    protected :getTwitterProfileBackgroundImageUrl, :fetchRemoteImage, :downloadTwitterWebPage

  end
end
