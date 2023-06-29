module UserProfilesHelper
  def human_readable_available_time(available_time)
    return "" if available_time.nil?

    I18n.t("activerecord.attributes.user_profile.#{available_time}")
  end
end
