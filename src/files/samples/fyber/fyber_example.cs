using UnityEngine;
using UnityEngine.UI;
using System.Collections;
using SponsorPay;
using Soomla;
using Soomla.Store;
using System;

public class FyberRvExample : MonoBehaviour {

	private static readonly string APP_ID = "YOUR_FYBER_APPID";
	private static readonly string SECURITY_TOKEN = "YOUR_FYBER_SECURITY_TOKEN";
	private static readonly string USER_ID = "YOUR_USER_ID";

	private Button reqVideo, showVideo;

	private SponsorPayPlugin sponsorPayPlugin;

	void Start () {
		sponsorPayPlugin = SponsorPayPluginMonoBehaviour.PluginInstance;

		// Initialize GUI
		reqVideo = GameObject.Find("RequestVideo").GetComponent<Button>();
		showVideo = GameObject.Find("ShowVideo").GetComponent<Button>();

		reqVideo.interactable = false;
		showVideo.interactable = false;

		reqVideo.onClick.RemoveAllListeners();
		reqVideo.onClick.AddListener(delegate {
			sponsorPayPlugin.RequestBrandEngageOffers (null, true);
		});
		showVideo.onClick.RemoveAllListeners();
		showVideo.onClick.AddListener(delegate {
			sponsorPayPlugin.StartBrandEngage();
			showVideo.interactable = false;
		});

		//Fyber SDK callbacks
		sponsorPayPlugin.OnNativeExceptionReceived +=
			new SponsorPay.NativeExceptionHandler (OnNativeExceptionReceivedFromSDK);
		sponsorPayPlugin.OnSuccessfulCurrencyRequestReceived +=
			new SponsorPay.SuccessfulCurrencyResponseReceivedHandler(OnSuccessfulCurrencyResponseReceived);
		sponsorPayPlugin.OnDeltaOfCoinsRequestFailed +=
			new SponsorPay.ErrorHandler(OnSPDeltaOfCoinsRequestFailed);
		sponsorPayPlugin.OnBrandEngageRequestResponseReceived +=
			new SponsorPay.BrandEngageRequestResponseReceivedHandler (OnSPBrandEngageResponseReceived);
		sponsorPayPlugin.OnBrandEngageRequestErrorReceived +=
			new SponsorPay.BrandEngageRequestErrorReceivedHandler (OnSPBrandEngageErrorReceived);
		sponsorPayPlugin.OnBrandEngageResultReceived +=
			new SponsorPay.BrandEngageResultHandler (OnMBEResultReceived);

		// Initialize Fyber SDK with your App ID, Security Token, and User ID
		sponsorPayPlugin.Start(APP_ID, USER_ID, SECURITY_TOKEN);

		// Initialize SOOMLA Store
		SoomlaStore.Initialize(new YourStoreAssetsImplementation());
	}

	public void OnNativeExceptionReceivedFromSDK(string message){
		// Native exceptions occurring within the Fyber Plugin
	}

	public void OnSuccessfulCurrencyResponseReceived(SuccessfulCurrencyResponse response)
	{
		//
        //  CurrencyId: ID of the Virtual Currency defined in the Fyber Dashboard
        //  This example assumes the ID is identical to the Virtual Item ID
        //  defined in your Store Assets Implementation
        //  DeltaOfCoins: Amount of VC to be given
        //
        int amount = (int) response.DeltaOfCoins;

        if(amount > 0) {
             StoreInventory.GiveItem(response.CurrencyId, amount);
        }
	}

	public void OnSPDeltaOfCoinsRequestFailed(SponsorPay.RequestError error)
	{
		showToast("An error occurred while requesting currency");
	}

	public void OnSPBrandEngageResponseReceived(bool offersAvailable)
	{
		if (offersAvailable) {
			showVideo.interactable = true;
		} else  {
			showVideo.interactable = false;
		}
	}

	public void OnSPBrandEngageErrorReceived(string message)
	{
		showVideo.interactable = false;
	}

	public void OnMBEResultReceived(string message)
	{
		// Message types:
		// CLOSE_FINISHED	User has successfully completed the engagement
		// CLOSE_ABORTED		User has cancelled the engagement before finishing it
		// ERROR				An unknown error has occurred
		// Since we are triggering a VCS request automatically, we don not have to do anything here
	}

}
