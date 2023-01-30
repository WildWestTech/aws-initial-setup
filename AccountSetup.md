# Pre-Reqs

- We'll need to do some console work before we get going.  
- Let's start by setting up an account.  
- We'll make sure to use MFA
- Additionally, we'll federate our accounts, leveraging AWS SSO (IAM Identity Center) to segregate our root (billing), dev, and prod environments.

## Phase 1: Setting up an AWS Account
- grab your credit card, you'll need it
- have your email addresses handy:
  - create root email address (first email you'll use to create your aws account)
  - create dev email address (needed for dev account)
  - create prod email address (needed for prod account)
  - create non-root admin email address (needed for first non-root admin user)
- create aws account, using root email address
  - note on the account name: 
    - consider appending something like "-root", "-billing", "-mgmt"
    - when we federate our accounts, it will be nice to have this one set aside for billing and maintenance purposes 
- navigate to security -> setup MFA
  - note on "name your device":
    - {device-name}@account will show up in your authenticator app (at least it does in mine)
    - for this reason, i use the name of my root email account for ease of navigation within my app

## Phase 2: AWS Organizations (root, dev, prod)

- navigate to organization (top-right, main drop-down)
- "create an organization" (one click)
- verify your email (root email)
- next, we'll add additional accounts to our org.
- AWS Organizations -> AWS Accounts -> Invitations -> Invite AWS Account
  - I'll choose to Create an AWS Account (once for dev, once for prod, each require their own unique email addresses)

## Phase 3: AWS Identity Center (SSO)

- navigate to the aws identity Center
- click "Enable"
- under "Settings Summary", navigate to the AWS access portal URL and customize the link to your liking
  - ex: https://wildwesttech.awsapps.com/start
- Choose your identity source.
  - This could be something like Microsoft Active Directory, but I'll stick with the (AWS) Identity Center
- Continue the process -> navigate to Authentication.
  - I'm choosing MFA.
  - I'm forcing users to setup their MFA device on their first sign-in.

## Phase 4: Create Users, Groups, and Permission Sets

- (We'll want to navigate away from using root soon)
- In the identity center:
  - Groups -> Create Group -> "admins" or something along those lines
  - Users -> Create a user -> enter the email address along with any other info -> add them to the new group
  - Note: users will need to verify their accounts (accept invitation) via email, then create a password
  - Multi-account permissions -> Create a permission set.  
    - start with the predefined AdministratorAccess set
    - our first goal is to move away from using the root account
    - our subsequent goals will be to create more restrictive permission sets for the remaining users/groups
  - Note on permission sets: this is a set of permissions that can be applied to one or multiple accounts

## Phase 5: Combining Users, Groups, Permission Sets, and Accounts

- If you are new to AWS and SSO, this might feel a bit different.
- Remember, we have multiple accounts
- Navigate to one of the accounts, let's start with the dev account
  - Multi-Account permissions 
  - AWS Accounts (choose an account) 
  - Think about who will be part of that account?  Choose the group(s) or user(s), preferably groups
  - Assign at least one permission set to that group
  - Review and submit 
- Repeat this for the remaining accounts, or don't.  Your call.

## Phase 6: Quick Review

- We should be able to navigate to our new AWS Single Sign-On Page
- Using our new username, backed by a non-root email address, we should be able to login to the SSO page
- We will have to use our MFA device
- Once logged in, we should see an AWS Accounts tile
- That tile should expand to to show each of the accounts we are now a member of
- Each of those accounts should now expand to show each of the permission sets we can use to login with
- For each permission set, we should be able to either access the management console and/or grab the temporary CLI credentials

## Phase 7: Delegation (Optional)

In order to fully manage permissions for your organization, you need to modify permission sets.  This occurs mainly through the IAM Identity Center, which is managed by the root account.  If you choose to delegate this management, you can take the following steps.  However, you can only delegate this administration to one other account at the moment, so you might want to either stick with your root account or create another account, dedicated to management, as opposed to using one of the dev or prod accounts.  In addition to which accounts have been registered as delegated administrators, these accounts would also require permission sets with permissions sufficient to perform IAM management tasks.  If for example an account was assigned two permission sets, AdministratorAccess and DataScientist, even if the account was delegated as an administrator, you could only perform IAM Identity Center tasks when entering through the AdministratorAccess permission set, but not while entering through the DataScientist permission set.

- Navigate to the the AWS-SSO page
- Using your root account, enter the management console
- Navigate to the IAM Identity Center
  - Settings
  - Management
  - Delegated administrator
  - Select an account and register

## Phase 8: Create Additional Permission Sets (Optional)

We are currently focusing on getting things up and running.  However, we won't give everyone full adminstrator access.  I'll dedicate more time and effort to this section later.  I plan on walking through custom in-line policies at some point.  For now, we'll just create a ViewOnlyAccess set.

- Navigate to AWS-SSO
- Login to the management console as the root user
- Enter the IAM Identity Center
- Navigate to Permission Sets
  - Choose "ViewOnlyAccess" then select next and create
  - Next, go to Groups and create a group
    - name it something like "ViewOnlyAccess" or "ViewOnly"
    - add yourself (or another available user) to the group
- Now navigate to AWS Accounts (under multi-account permissions)
  - Select your dev and prod account, then add users or groups
    - Choose your newly created group
      - Select the newly created permission set, then next and submit

At this point, you may need to logout and then log back in to your AWS-SSO portal, but then you should now see an additional permission set under your dev and prod accounts.  This is the first step to working with granular permissions.  As mentioned above, I plan on spending more time focusing on the granular permissions that fall somewhere between ViewOnlyAccess and full AdministratorAccess.  But for now, this will give you a good baseline for being able to do just about everything and also spotting what you cannot do.
