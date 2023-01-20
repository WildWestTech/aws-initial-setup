# aws-infra

# aws-infra

#####################################################################
# Phase 1: setting up the root account
#####################################################################
# create root email address
# create dev email address (needed for dev account)
# create prod email address (needed for prod account)
# create aws account, using root email address
#   note on the account name:
#       consider appending something like "-root", "-billing", "-mgmt"
#       when we federate our accounts, it will be nice to have this one set aside for billing and maintenance purposes
# navigate to security -> setup MFA
#   note on "name your device": 
#       {device-name}@account will show up in your authenticator app
#       for this reason, i use the name of my root email account for ease of navigation within my app
#####################################################################
# Phase 2: AWS Organizations (root, dev, prod)
#####################################################################
# navigate to organization (top-right, main drop-down)
# "create an organization" (one click)
# verify your email

# AWS Organizations -> AWS Accounts -> Invitations -> Invite AWS Account
#   I'll choose to Create an AWS Account (once for dev, once for prod, each require their own unique email addresses)
#####################################################################
# Phase 3: AWS Identity Center (SSO)
#####################################################################
# navigate to the aws identity Center
# click "Enable"
# under "Settings Summary", navigate to the AWS access portal URL and customize the link to your liking
#   ex: https://wildwesttech.awsapps.com/start
# Choose your identity source.  This could be something like Microsoft Active Directory, but I'll stick with the (AWS) Identity Center
# Continue the process -> navigate to Authentication.  I'm choosing MFA.
#   I'm forcing users to setup their MFA device on their first sign-in.
#####################################################################
# Phase 4: Create Users, Groups, and Permission Sets
#####################################################################
(We'll want to navigate away from using root soon)
# In the identity center:
#   Groups -> Create Group -> "admins" or something along those lines
#   Users -> Create a user -> enter the email address along with any other info -> add them to the new group
#       Note: users will need to verify their accounts (accept invitation) via email, then create a password
#   Multi-account permissions -> Create a permission set - start with the predefined AdministratorAccess set

#   Note on permission sets: this is a set of permissions that can be applied to one or multiple accounts
#####################################################################
# Phase 5: Combining Users, Groups, Permission Sets, and Accounts
#####################################################################
# If you are new to AWS and SSO, this might feel a bit different.
# Remember, we have multiple accounts
# Navigate to one of the accounts, let's start with the dev account
#   -> Multi-Account permissions 
#   -> AWS Accounts (choose an account) 
#   -> Think about who will be part of that account?  Choose the group(s) or user(s), preferably groups
#   -> Assign at least one permission set to that group
#   -> Review and submit 
# Repeat this for the remaining accounts, or don't.  Your call.
#####################################################################
# Phase 6: Quick Review
#####################################################################
# We should be able to navigate to our new AWS Single Sign-On Page
# Using our new username, backed by a non-root email address, we should be able to login to the SSO page
# We will have to use our MFA device
# Once logged in, we should see an AWS Accounts tile
# That tile should expand to to show each of the accounts we are now a member of
# Each of those accounts should now expand to show each of the permission sets we can use to login with
# For each permission set, we should be able to either access the management console and/or grab the temporary CLI credentials
