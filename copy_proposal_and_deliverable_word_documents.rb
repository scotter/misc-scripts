
def get_child_directories(d)
  children = Dir.entries(d).reject{ |e| ['.','..','.DS_Store'].include?(e) }
  children = children.map{ |e| File.join(d,e) }
  children.select{ |e| File.directory?(e) }
end

current_projects = get_child_directories('T:/Consulting/Current')

word_doc_folders = []
current_projects.each do |p|
  children = get_child_directories(p)
  children = children.select { |c| c.include?('Proposal') || c.include?('Delivered') }
  if children.any?
    puts children.inspect 
    word_doc_folders << children
  end
end
word_doc_folders = word_doc_folders.flatten


files_to_copy = []
word_doc_folders.each do |folder|
  Dir.chdir(folder) do
    ['**/*.doc','**/*.docx'].each do |g|
      Dir.glob(g) { |file| files_to_copy << File.join(folder,file) unless file.start_with?('~') }  
    end
  end
end

files_to_copy.uniq!

require 'fileutils'
files_to_copy.each do |f|
  FileUtils.cp(f, 'C:/Collected for Google Drive')
end
