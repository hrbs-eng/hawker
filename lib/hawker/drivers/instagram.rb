require "json"

module Hawker
  module Drivers
    class Instagram < Hawker::Drivers::Default

      # The current user biography
      #
      # @return [String]
      def biography
        json["entry_data"]["ProfilePage"].first["graphql"]["user"]["biography"]
      end

      # The current user full name
      #
      # @return [String]
      def full_name
        json["entry_data"]["ProfilePage"].first["graphql"]["user"]["full_name"]
      end

      # The current user followers count
      #
      # @return [Integer]
      def followers
        json["entry_data"]["ProfilePage"].first["graphql"]["user"]["edge_followed_by"]["count"]
      end

      # The number of accounts that the current user follows
      #
      # @return [Integer]
      def following
        json["entry_data"]["ProfilePage"].first["graphql"]["user"]["edge_follow"]["count"]
      end

      # The current user external URL that is present in the biography
      #
      # @return [String]
      def external_url
        json["entry_data"]["ProfilePage"].first["graphql"]["user"]["external_url"]
      end

      # The current user profile picture URL
      #
      # @return [String]
      def profile_pic_url
        json["entry_data"]["ProfilePage"].first["graphql"]["user"]["profile_pic_url"]
      end

      # The current user Instagram username
      #
      # @return [String]
      def username
        json["entry_data"]["ProfilePage"].first["graphql"]["user"]["username"]
      end

      # The current images shown in the Instagram user page
      #
      # @return [Array]
      def images()
        images = json["entry_data"]["ProfilePage"].first["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
        images.map do |img|
          {
            image_url: img["node"]["display_url"],
            caption: img["node"]["edge_media_to_caption"]["edges"].first["node"]["text"],
            shortcode: img["node"]["shortcode"],
            url: "https://instagram.com/p/#{img["node"]["shortcode"]}/",
          }
        end
      end

      # The scraped JSON object
      #
      # @return [Object]
      def json
        @json ||= begin
          raw_json = html.to_s.match(/window\._sharedData =.*(?=;)/)
          JSON.parse(raw_json.to_s.gsub("window._sharedData = ", ""))
        end
      end
    end
  end
end
