class EntriesController < ApplicationController
  def sign_in
  	@name= params[:visitor_name]
  	ref_e= params[:id].nil?; # true-->nothing in url, false--> something in url
  	ref= params[:id];
	  valid= Entry.find_by(unique: ref).nil? # true==> fake false==> real

#	if  valid= Entry.find_by(unique: ref).nil? 
#	 render "entries/unknown"
#	end
#	  puts	"------------------------------>>>>>>> #{ref}, #{valid} "
#  	unless @name.blank?    #false, Entry.find_b(name: @name).nil? true,-->
  
	if !(@name.blank?) && (Entry.find_by(name: @name).nil?) 
      @unique_hex= SecureRandom.hex(10);
  		@entry= Entry.create({:name =>@name, :unique => @unique_hex})
		if !(valid) && !(ref_e) 		
			obj_ref=Entry.find_by(unique: ref);
			obj_ref.friend ||= 0
			obj_ref.friend= obj_ref.friend+1;
			obj_ref.update({:friend => obj_ref.friend});
  			puts "------------------------------>>>>>>>>>#{obj_ref.friend}"
  		end
  	end
  		@entries= Entry.all
#  		render "entries/ongoing"
  end

#  def ongoing
#  	@entries_1= Entry.all
# end
def welcome
	@entries1= Entry.all

end


end