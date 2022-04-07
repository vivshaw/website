module Badges
  class Mentor500Badge < Badge
    seed "Mentor",
      :ultimate,
      :mentor,
      "Mentored 500 students"

    def award_to?(user)
      user.mentor_discussions.joins(:request).
        where(status: :finished).
        select('mentor_requests.student_id').
        distinct.
        count >= 500
    end

    def send_email_on_acquisition?
      false
    end
  end
end
