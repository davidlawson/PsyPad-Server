# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  authentication_token   :string
#  string                 :string
#  created_at             :datetime
#  updated_at             :datetime
#  role                   :string
#  affiliation            :string
#

class User < ActiveRecord::Base

  # https://github.com/gonzalo-bulnes/simple_token_authentication
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :participants, dependent: :destroy
  has_many :image_sets, dependent: :destroy
  has_many :logs, dependent: :destroy

  belongs_to :default_participant, class_name: 'Participant'

  def admin?
    role == 'admin'
  end

  def to_s
    email
  end

end
