def substrings(text, dictionary)
  result = {}
  dictionary.each do |word|
    matches = text.downcase.scan(word).length
    result[word] = matches unless matches.zero?
  end

  result
end

dictionary = ["below","down","go","going","horn","how","howdy","it","i","low","own","part","partner","sit"]
substrings("below", dictionary)
substrings("Howdy partner, sit down! How's it going?", dictionary)
