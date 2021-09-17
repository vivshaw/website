require_relative "../../../../../app/helpers/react_components/student/mentoring_session/mentor"
require "mocha/minitest"

module ReactComponents
  module Student
    class MentoringSession
      class MentorTest < ActiveSupport::TestCase
        test "renders json" do
          mentor = stub(name: "Name")
          relationship = stub(num_discussions: 10)
          Mentor.mentor_keys = %i[name]
          Mentor.relationship_keys = %i[num_discussions]

          assert_equal(
            { name: "Name", num_discussions: 10 },
            Mentor.new(mentor, relationship).as_json
          )
        end

        test "renders nil if mentor is nil" do
          mentor = nil
          relationship = stub

          assert_nil Mentor.new(mentor, relationship).as_json
        end

        test "renders 0 num discussions if relationship is nil" do
          mentor = stub(name: "Name")
          relationship = nil
          Mentor.mentor_keys = %i[name]
          Mentor.relationship_keys = %i[num_discussions]

          assert_equal(
            { name: "Name", num_discussions: 0 },
            Mentor.new(mentor, relationship).as_json
          )
        end
      end
    end
  end
end
