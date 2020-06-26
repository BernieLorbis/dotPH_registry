class Domain < ApplicationRecord

	validates_format_of :q, with: /\A[a-z\d][a-z\d-]*[a-z\d]\z/i

	has_one :registrant
end
