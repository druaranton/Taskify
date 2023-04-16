# project_aranton
A Flutter mobile application composed of a sign in, sign-up and a shared todo list features with a user’s friends

### Andreau O. Aranton
### 2020-00947
### D-1L

## Note for automated testing
Test files are found in the test folder. Before testing, the user must comment necessary lines of code and uncomment others based on what is discussed in the handout(for the mock auth and fake db). Not doing so will result to failed tests.

## Screenshots
Log-in Page
    ![image](http://drive.google.com/uc?export=view&id=1WOnlDSPMTSDArMVcUvKcfJWCzlAPkyhQ)

Sign-up Page
![image](http://drive.google.com/uc?export=view&id=1k5gyW6ugaAg9mAOoYjU0-W14ZuSF0tOT)

My Profile Page
![image](http://drive.google.com/uc?export=view&id=1E1OToPgGGqCUk7k3KmuZbWqSJHRYlxpo)

Shared Todos Page
![image](http://drive.google.com/uc?export=view&id=1DB3rQTI14QbCzcwG2UmGI27AGybE7zCq)

Friends Page
![image](http://drive.google.com/uc?export=view&id=1SEo3wUnQrfBSKNFT-V7N9OKkrKnzxG9o)

Search Page
![image](http://drive.google.com/uc?export=view&id=1o5bPFIxqB9f2jArof4bhzzap0a-6Eq3T)

Edit a Todo
![image](http://drive.google.com/uc?export=view&id=1YBc6d2YLOjnxXTrOzGAzWVj3NrqQSomz)

View a Todo
![image](http://drive.google.com/uc?export=view&id=1E0QYdqi3VPxhmV0Z65QmRHq18-hCmswq)

Todo Notification upon deadline
![image](http://drive.google.com/uc?export=view&id=1kFvGIDX1Yh5yw0UTP4-CHn-JHCYegWhE)

View a friend's profile page
![image](http://drive.google.com/uc?export=view&id=1gSeHEfSnV8frgDH2GYLuD7vmG05g0OF3)

Additional: Notification page
![image](http://drive.google.com/uc?export=view&id=1s-x46hguyoV_HuXj9xYgOJQgt4kV3-nQ)

## Things you did in the code
Basically I used all the things that I have learned from the previous lessons and exercises in this project. I used the codes from the handouts and also my previous exer to build some of the parts of my project. For the other parts, I studied them online and then build them up little by little.

## Challenges faced
I encountered many challenges while doing this project. First, I encountered a time when the app/tab would just keep on loading after switching and returning tabs. I also had a difficult time implementing the notifications.

## Test Cases
Happy paths:  
    1. Correct Navigation of buttons  
        Upon launching of app:  
        a. Find sign up buutton  
        b. Click sign up button  
        c. Find back button  
        d. Click back button  
        e. Find sign-up button  
    2. Successful login:    
        Email: druaranton123@gmail.com    
        Password: Qwerty1!  
    3. Successful sign-up:  
        First name: Andreau  
        Last Name: Aranton  
        Birthdate: 2001-11-30  
        Location: Pila  
        Email: andruaranton@gmail.com  
        Username: xdrux  
        Password: cmsc23123A!  
    4. Successful loading of initial widgets:  
        a. Find the email text foom  
        b. Find the password text form  
        c. Find the log-in button  
        d. Find the sign up button  

  
Unhappy paths:  
    1. Signing up with empty first name, birthdate, location, and username  
        a. Last name: Aranton  
        b. Email:andruaranton@gmail.com  
        c. Password: Qwerty1!  
    2. Signing up with a weak password  
        First name: Andreau  
        Last Name: Aranton  
        Birthdate: 2001-11-30  
        Location: Pila  
        Email: andruaranton@gmail.com  
        Username: xdrux  
        Password: cmsc23123  
    3. Logging in with a weak password  
        Email: andreauaranton@gmail.com  
        Password: cmsc23123  
    4. Logging in with an incorrect email format  
        Email: andreauaranton  
        Password: cmsc23123A!  