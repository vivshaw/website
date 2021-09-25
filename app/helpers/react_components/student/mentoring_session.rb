module ReactComponents
  module Student
    class MentoringSession < ReactComponent
      initialize_with :solution, :request, :discussion

      def to_s
        super(
          "student-mentoring-session",
          {
            user_handle: student.handle,
            request: SerializeMentorSessionRequest.(request, student),
            discussion: discussion ? SerializeMentorDiscussion.(discussion, student) : nil,
            track: SerializeMentorSessionTrack.(track),
            exercise: SerializeMentorSessionExercise.(exercise),
            iterations: iterations,
            mentor: SerializeMentor.(mentor, mentor_student_relationship),
            track_objectives: user_track&.objectives.to_s,
            out_of_date: solution.out_of_date?,
            videos: videos,
            links: {
              exercise: Exercism::Routes.track_exercise_mentor_discussions_url(track, exercise),
              create_mentor_request: Exercism::Routes.api_solution_mentor_requests_path(solution.uuid),
              learn_more_about_private_mentoring: Exercism::Routes.doc_path(:using, "feedback/private"),
              private_mentoring: solution.external_mentoring_request_url,
              mentoring_guide: Exercism::Routes.doc_path(:using, "feedback/guide-to-being-mentored")
            }
          }
        )
      end

      private
      attr_reader :solution, :request, :discussion

      delegate :track, :exercise, to: :solution

      memoize
      def mentor_student_relationship
        return unless mentor

        Mentor::StudentRelationship.find_by(mentor: mentor, student: student)
      end

      memoize
      def mentor
        discussion&.mentor
      end

      memoize
      def student
        solution.user
      end

      memoize
      def user_track
        UserTrack.for(student, track)
      end

      def videos
        return [] if discussion

        [
          {
            url: Exercism::Routes.doc_path(:using, "feedback/guide-to-being-mentored"),
            thumb: "https://exercism-static.s3.eu-west-1.amazonaws.com/blog/tutorial-making-the-most-of-being-mentored.png",
            title: "Making the most of being mentored",
            date: Date.new(2021, 9, 1).iso8601
          }
        ]
      end

      def iterations
        if discussion
          comment_counts = discussion.posts.
            group(:iteration_id, :seen_by_student).
            count
        end

        solution.iterations.map do |iteration|
          counts = discussion ? comment_counts.select { |(it_id, _), _| it_id == iteration.id } : nil
          unread = discussion ? counts.reject { |(_, seen), _| seen }.present? : false

          SerializeIteration.(iteration).merge(unread: unread)
        end
      end

      class SerializeMentor
        include Mandate

        USER_KEYS = %i[name handle bio languages_spoken avatar_url formatted_reputation].freeze
        RELATIONSHIP_KEYS = %i[num_discussions].freeze

        initialize_with :mentor, :relationship

        def call
          return nil unless mentor

          user_hash.merge(relationship_hash)
        end

        def user_hash
          build(mentor, USER_KEYS).merge(
            pronouns: mentor.pronoun_parts
          )
        end

        def relationship_hash
          build(relationship || NullRelationship.new, RELATIONSHIP_KEYS)
        end

        def build(object, keys)
          keys.index_with do |key|
            object.send(key)
          end
        end

        class NullRelationship
          def num_discussions
            0
          end
        end
      end
    end
  end
end
