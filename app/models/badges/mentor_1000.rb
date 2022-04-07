module Badges
  class Mentor1000Badge < Badge
    seed "Mentor",
      :legendary,
      :mentor,
      "Mentored 1000 students"

    def award_to?(user)
      user.mentor_discussions.joins(:request).
        where(status: :finished).
        select('mentor_requests.student_id').
        distinct.
        count >= 1000
    end

    def send_email_on_acquisition?
      false
    end
  end
end
