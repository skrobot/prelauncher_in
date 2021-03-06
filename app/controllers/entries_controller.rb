class EntriesController < ApplicationController
  def sign_in
    #  	@name= params[:visitor_name]
    @email = params[:email]
      ref_e = params[:id].nil? # true-->nothing in url, false--> something in url
    ref = params[:id]
    obj_ref = Entry.find_by(unique: ref)
    valid = Entry.find_by(unique: ref).nil? # true==> fake false==> real

    
    @visited = !Entry.find_by(ip: request.remote_ip).nil?
    session_entry = Entry.find_by(:session => session.id)
#  if entry&.email.present?
#     redirect_to(:action => 'welcome', :email => entry.email)
#  end

# => visited T
# =>    session T  ==> happens ==> should redirect to welcome

# =>        email T ===> normal user
# =>        email F ===> possible crazyness
# =>    session F  ==> happens ==> COOKIE erase
# =>        email T ==> normal use 
# =>        email F ==> ?
# => visted F
# =>    session T ==> happens should redirect to welcome
# =>        email T  ==> nomal user
# =>        email F  ==> 
# =>    session F ==> normal user
# =>        email T
# =>        email F
# =>        
# =>        when vistied && session is true email is false ==> then do something about it
    if @email.present? && @email.match(URI::MailTo::EMAIL_REGEXP).present?
      entry = Entry.find_by(email: @email)
#      if @visited && !(entry.nil?)
      if !(entry.nil?)
      UserMailer.signup_confirmation(@email).deliver

        entry.update({:session => session.id})
        redirect_to(:action => 'welcome', :email => @email)
      end
      if entry.nil?
#      if !@visited && entry.nil?
        @unique_hex = SecureRandom.hex(10)
        UserMailer.signup_confirmation(@email).deliver

        @entry = Entry.create({
          :email => @email,
          :unique => @unique_hex,
          :ip => request.remote_ip,
          :session => session.id
        })

        if !(valid) && !(ref_e)
          obj_ref = Entry.find_by(unique: ref)
          obj_ref.friend ||= 0
          obj_ref.friend = obj_ref.friend + 1
          obj_ref.update({:friend => obj_ref.friend})
          @entry.update({:wrefered => obj_ref.email})
        end

        redirect_to(:action => 'welcome', :email => @email)
      end
# malicious user
    end
  end


  def welcome
    email = params[:email]
    full_numb_ref = 20

    @user = Entry.find_by(email: email)
    @unique = @user.unique
    puts "-------------------------------------------___>>>>>>>>>>>>>>> #{@unique}"
    @percentage = (@user.friend) * (100 / full_numb_ref)
    puts "----------------------11-------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>#{@user.friend}*5  #{@percentage}"
    @entries1 = Entry.all

  end
end
