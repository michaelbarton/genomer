RSpec::Matchers.define :have_same_fields do |expected|
  match do |actual|
    attributes_to_hash(actual) == attributes_to_hash(expected)
  end
  diffable
end

def attributes_to_hash(gff)
  fields = [:end,:feature,:frame,:score,:seqname,:source,:strand]
  hash = fields.inject(Hash.new) do |h,f|
    h[f] = gff.send(f)
    h
  end
  hash[:attributes] = gff.attributes.sort
  hash
end
