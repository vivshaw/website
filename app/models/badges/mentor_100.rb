module Badges
  class Mentor100Badge < Badge
    seed "Mentor",
      :rare,
      :mentor,
      "Mentored 100 students"

    def award_to?(user)
      user.mentor_discussions.joins(:request).
        where(status: :finished).
        select('mentor_requests.student_id').
        distinct.
        count >= 100
    end

    def send_email_on_acquisition?
      false
    end
  end
end
