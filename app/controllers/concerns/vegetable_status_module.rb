# frozen_string_literal: true

module VegetableStatusModule
  extend ActiveSupport::Concern

  STATUS_MAP = {
    /healthy/ => 'healthy',
    /disease|pest/ => 'disease_or_pest',
    /ripe|harvest/ => 'ripe_or_harvest',
    /dry|wilting|yellowing/ => 'dry_or_wilting',
    /overripe|rotten/ => 'overripe_or_rotten',
    /underripe|immature/ => 'underripe_or_immature',
    /flowering|blossom/ => 'flowering',
    /fruiting|bearing fruit/ => 'fruiting',
    /weed|grass/ => 'weed_or_grass',
    /insect|bug/ => 'insect_or_bug',
    /drought|dry soil/ => 'drought',
    /fungal|mold/ => 'fungal_or_mold',
    /nutrient deficiency|yellow leaves/ => 'nutrient_deficiency',
    /overwatering|waterlogged/ => 'overwatering',
    /stunted growth|small size/ => 'stunted_growth',
    /sunburn|burnt leaves/ => 'sunburn',
    /overgrown|too large/ => 'overgrown',
    /undergrown|too small/ => 'undergrown',
    /viral infection|virus/ => 'viral_infection',
    /inappropriate temperature|temperature stress/ => 'inappropriate_temperature'
  }.freeze

  def determine_vegetable_status(labels)
    vegetable_status = {}

    labels.each do |label|
      status = determine_status(label)
      vegetable_status[:status] = status if status
    end

    vegetable_status[:status] ||= I18n.t('vegetable_status.other')

    vegetable_status
  end

  private

  def determine_status(label)
    STATUS_MAP.each do |pattern, status|
      return I18n.t("vegetable_status.#{status}") if label.downcase =~ pattern
    end
    nil
  end
end
