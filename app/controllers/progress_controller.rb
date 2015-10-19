class ProgressController < ApplicationController

    def check
        
    end

    def view

        user = Participant.find(params[:user_id])

        @logs = Log.where(:user_id => user)
    end

    def all
       # @participants = Participant.all 
       @logs = Log.all
    end

        
end
