namespace :tones do

  desc "Take all translation strings from database and search in appication, if any unused string found then remove from database and update tones.csv"
  task :remove_unused_string => :environment do
    unused_string = []
    files = Dir['app/**/helpers/**/*', 'app/**/controllers/**/*', 'app/**/views/**/*', 'app/**/mailers/**/*'].select{|f| File.file?(f)}
    Tones::Tone.all.each do |tone|
      is_found = false
      tone_strings = []
      tone_strings << 'to\(:' + tone.name + '\)'
      tone_strings << 'to\(\"' + tone.name + '\"\)'
      tone_strings << 'to\(\'' + tone.name + '\'\)'
      files.each do |f|
        tone_strings.each do |tnst|  
          is_found = open(f).grep(/#{tnst}/).present?
          break if is_found  
        end
        break if is_found
      end
    unused_string << tone unless is_found
    end
    if unused_string.present? 
      puts "#{unused_string.size} unused translation #{'string'.pluralize(unused_string.size)} found in database \n\n"
      puts unused_string.map(&:name)
      puts "#{unused_string.size} unused translation strings found in database" if unused_string.size > 20
    else
      puts "All translation string are using application"
    end
  end

end
