module ReactComponents
  module Student
    class MentoringSession
      class Mentor
        class << self
          attr_writer :mentor_keys, :relationship_keys

          def mentor_keys
            @mentor_keys || %i[name handle bio languages_spoken avatar_url formatted_reputation pronouns]
          end

          def relationship_keys
            @relationship_keys || %i[num_discussions]
          end
        end

        def initialize(mentor, relationship)
          @mentor = mentor
          @relationship = relationship || NullRelationship.new
        end

        def as_json
          return nil unless mentor

          mentor_json.merge(relationship_json)
        end

        private
        attr_reader :mentor, :relationship

        def mentor_json
          json(mentor, self.class.mentor_keys)
        end

        def relationship_json
          json(relationship, self.class.relationship_keys)
        end

        def json(object, keys)
          keys.index_with do |key|
            object.send(key)
          end
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
