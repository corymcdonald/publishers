require 'rubygems'
require 'json'

class SiteBanner < ApplicationRecord
  include Rails.application.routes.url_helpers
  include PublicS3

  has_one_public_s3 :logo

  has_one_public_s3 :background_image
  belongs_to :publisher

  LOGO = "logo".freeze
  LOGO_DIMENSIONS = [480,480]
  LOGO_UNIVERSAL_FILE_SIZE = 40_000 # In bytes

  BACKGROUND = "background".freeze
  BACKGROUND_DIMENSIONS = [2700,528]
  BACKGROUND_UNIVERSAL_FILE_SIZE = 120_000 # In bytes

  NUMBER_OF_DONATION_AMOUNTS = 3
  MAX_DONATION_AMOUNT = 20

  validates_presence_of :title, :description, :donation_amounts, :default_donation, :publisher
  validate :donation_amounts_in_scope
  before_save :clear_invalid_social_links

  #####################################################
  # Validations
  #####################################################

  def donation_amounts_in_scope
    return if errors.present? # Don't bother checking against donation amounts if donation amounts are nil
    errors.add(:base, "Must have #{NUMBER_OF_DONATION_AMOUNTS} donation amounts") if donation_amounts.count != NUMBER_OF_DONATION_AMOUNTS
    errors.add(:base, "A donation amount is zero or negative") if donation_amounts.select { |donation_amount| donation_amount <= 0}.count > 0
    errors.add(:base, "A donation amount is above a target threshold") if donation_amounts.select { |donation_amount| donation_amount >= MAX_DONATION_AMOUNT}.count > 0
  end

  # (Albert Wang) Until the front end can properly handle errors, let's not block save and only clear invalid domains
  def clear_invalid_social_links
    return if errors.present? || social_links.nil?
    require 'addressable'
    self.social_links = self.social_links.select { |key,_| key.in?(["twitch", "youtube", "twitter"]) }

    unless self.social_links["twitch"].blank? || Addressable::URI.parse(self.social_links["twitch"]).normalize.host.in?(["www.twitch.tv", "twitch.tv"])
      self.social_links["twitch"] = ""
    end

    unless self.social_links["youtube"].blank? || Addressable::URI.parse(self.social_links["youtube"]).normalize.host.in?(["www.youtube.com", "youtube.com"])
      self.social_links["youtube"] = ""
    end

    unless self.social_links["twitter"].blank? || Addressable::URI.parse(self.social_links["twitter"]).normalize.host.in?(["www.twitter.com", "twitter.com"])
      self.social_links["twitter"] = ""
    end
  end

  #####################################################
  # Methods
  #####################################################

  def read_only_react_property
    {
      title: self.title,
      description: self.description,
      backgroundUrl: self.public_background_image_url,
      logoUrl: self.public_logo_url,
      donationAmounts: self.donation_amounts,
      socialLinks: self.social_links
    }
  end
end
