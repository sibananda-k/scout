class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable, :invitable
  # has_secure_password
  attr_accessor  :new_organisation_name
  attr_accessor :is_signup 
  has_many :user_roles
  has_many :organisations, through: :user_roles
  has_many :roles, through: :user_roles
  belongs_to :invited_by, class_name: "User", optional: true
  before_save :validate_organisation,unless: :invited?
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  validates :timezone, presence: true

  def role_for_organisation(organisation)
    user_role = user_roles.find_by(organisation: organisation)
    user_role&.role
  end

  def invited?
    invitation_sent_at.present?
  end

  def save_organisation
    if new_organisation_name.present?
      organisation = Organisation.new(organisation_name: new_organisation_name)
  
      if organisation.save
        # owner_role = Role.find_by(name: "Owner")
        owner_role = Role.by_name('Owner')
        UserRole.create(user: self, organisation: organisation, role: owner_role)
        return true
      else
        organisation.errors.full_messages.each do |message|
          errors.add(:base, message)
        end
        return false
      end
    end
    true # If no organisation creation is needed, return true
  end

  private

  def validate_organisation
    if self.new_record?  # Check if it's a newly created user (signup)
      if new_organisation_name.blank?
        errors.add(:base, "Organisation name can't be blank.")
        throw(:abort)  # Prevent user from being saved
      end
      # Check if the organisation name already exists
      if Organisation.exists?(organisation_name: new_organisation_name)
        errors.add(:base, "Organisation name already exists. Please choose a different name.")
        throw(:abort)  # Prevent user from being saved
      end
    end
  end
    
end
