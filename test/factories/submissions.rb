FactoryBot.define do
  factory :submission do
    uuid { SecureRandom.compact_uuid }
    solution { build :concept_solution, track: track }
    submitted_via { "cli" }
    tests_status { :not_queued }

    trait :cli do
      submitted_via { "cli" }
    end

    trait :api do
      submitted_via { "api" }
    end

    transient do
      track do
        Track.find_by(slug: 'ruby') || create(:track, slug: 'ruby')
      end
    end
  end
end
