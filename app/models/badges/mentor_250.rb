module Badges
  class Mentor250Badge < Badge
    seed "Mentor",
      :ultimate,
      :mentor,
      "Mentored 250 students"

    def award_to?(user)
      user.mentor_discussions.joins(:request).
        where(status: :finished).
        select('mentor_requests.student_id').
        distinct.
        count >= 250
    end

    def send_email_on_acquisition?
      false
    end
  end
end
