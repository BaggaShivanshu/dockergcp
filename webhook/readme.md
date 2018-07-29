FIRST RUN:

pip install -t lib -r requirements.txt

THEN:

gcloud app deploy


**OTHER IDEAS**

[Early Access] Lab 8: Enabling Cloud IAP
Task 1. Turn on Cloud IAP
Return to your Google Cloud Platform tab.
On the Navigation menu, click Security > Identity-Aware-Proxy.
On the Identity-Aware Proxy page, under Resource, find the App Engine app you want to restrict access to. The Published column shows the URL of the app.
To turn on Cloud IAP for the app, in the IAP column, click On.
In the Turn on IAP dialog:
Verify that the automatically added domain matches the appspot.com domain where you expect to serve your application. You may see an additional preview/test domain listed as well, but this is OK.
To confirm that you want the application to be secured by Cloud IAP, click Turn On. After you turn it on, Cloud IAP requires login credentials for all connections to your application, and only accounts with the IAP-Secured Web App User role on this project are given access.
Test that you cannot access the App Engine website by refreshing an open tab or selecting the link in the Published section of the IAP page.
Task 2. Add a user to IAP and test access
In the right pane, click Add.
In the Add members dialog, add the email address being used from this Qwiklab and add the IAP-Secured Web App User role for this account.NOTE: To retrieve the email, return to the main Qwiklabs page you started the lab from. Under Connection Details, copy the Username by clicking the blue clipboard icon.
Click Add.
Turn off IAP using the link on the resource page.
Turn IAP back on (This is to ensure that we clear everything out since we are using Incognito windows).
Test that you can now access the App Engine site with the existing logged in user. You should now have access to the website.
Demo: Building Voice Chat with Actions for Google
Integrate your voice chat for your chatbot with Google Home or the Google Assistant app on iOS or Android via the Actions with Google integration.

https://developers.google.com/actions/console/setup-and-developing#apiai



On the Dialogflow main menu, click Intents.
Click on the Default Welcome Intent.
If Google Assistant Welcome is not listed under Events, add it, and then click Save.
Scroll to the bottom of the page and review the expressions in the Text Response table. These will be randomly selected by Google Assistant when your app starts. Feel free to add a few welcome statements of your own to personalize if you like and then click Save. Or you can just leave the defaults.
On the main menu, click Integrations, and then click Integration Settings under Google Assistant.
Confirm that the Explicit invocation is set to Default Welcome Intent, and then set the Implicit invocation to Topic.


Click Test. This opens your project/agent's page in the Actions on Google console. NOTE: If you are presented with a confirmation dialog, just click Continue. When Google prompts for terms click Accept.
On the navigation menu, click Invocation.
For Display name, type HR Manual, and then click Save. If HR Manual is already taken, name your app something unique, such as "<your name>'s HR Manual."
Add the same name for Directory title, and then click Save.


To test your Google Assistant–enabled chatbot, click the microphone icon and speak to the agent, or type in the test simulator console.
Say or type "Talk to <HR manual name>" to initiate the agent.
Say or type "Tell me about sick leave."
(Optional) Download Google Assistant on your iPhone or Android device. Log in to the App with your Google account. Say "Talk to the HR Manual." Ask questions as above.