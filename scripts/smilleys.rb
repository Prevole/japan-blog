def smilleys(content)
  " #{content}"
    .gsub(" :D", " :laughing:")
    .gsub(" ;)", " :wink:")
    .gsub(" :=", " :grin:")
    .gsub(" :(", " :confused:")
    .gsub(" :P", " :stuck_out_tongue_closed_eyes:")
    .gsub(" :O", " :grimacing:")
    .gsub(" :|", " :neutral_face:")
    .gsub(" :lol:", " :laughing:")
    .gsub(" :arf:", " :laughing:")
    .gsub(" &gt;&lt;", " :satisfied:")
    .gsub(" :jap:", " :smiley_cat:")
    .gsub(" :love:", " :heart:")
    .gsub(" :funk:", " :stuck_out_tongue:")
    .gsub(" :boulet:", " :dizzy_face:")
    .gsub(" :thunder:", " :zap:")
    .gsub(" :idea:", " :bulb:")
    .gsub(" :roll:", " :relieved:")
    .gsub(" :home:", " :house_with_garden:")
    .gsub(" :next:", " :arrow_right:")
    .gsub(" :siffle:", " :yum:")
    .gsub(" :auréole:", " :innocent:")
    .gsub(" :tux:", " :penguin:")
    .gsub(" :evil:", " :smiling_imp:")
    .gsub(" :...:", " :confounded:")
    .gsub(" :)", " :smiley:")
    .gsub(" =)", " :grimacing:")
    .gsub(" 8)", " :sunglasses:")
    .gsub(" 8P", " :sunglasses:")
    .gsub(" OO", " :open_mouth:")
    .gsub(" oO", " :open_mouth:")
    .gsub(" :/", " :confounded:")
    .gsub(" /|", " :boy:")
    .strip
end