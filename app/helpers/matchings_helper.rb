module MatchingsHelper
  def delete_matching!(matching)
    ActiveRecord::Base.transaction do
      matching.users.each do |user|
        user.delete_approved_chat_request_for_user(matching)
      end
      matching.destroy!
    end
  end
end
