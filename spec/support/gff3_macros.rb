RSpec::Matchers.define :have_same_fields do |expected|
  match do |actual|
    attributes_to_hash(actual) == attributes_to_hash(expected)
  end
  diffable
end


def attributes_to_hash(gff3)
  [:attributes,:end,:feature,:frame,:score,:seqname,
    :source,:strand].inject(Hash.new) do |hash,attr|
    hash[attr] = gff3.send(attr)
    hash
  end
end
