//
//  Event.swift
//  Affirma
//
//  Created by Airblack on 17/02/23.
//

import Foundation
enum Event: String {
    
    // MARK: Onboarding
    case landedOnLoginScreen = "landed on login screen" // source = deeplink
    case countryCodeChanged = "country code changed"
    case otpSent = "otp sent"
    case landedOnOtpScreen = "landed on otp screen"
    case otpVerified = "otp verified"
    case landedOnNameScreen = "landed on name screen"
    case nameEntered = "name entered"
    case landedOnNotificationScreen = "landed on notification screen"
    case notificationTimeChanged = "notification time changed"
    case notificationTimeEntered = "notification time entered"
    case notificationPermissionGranted = "notification permission granted"
    case notificationPermissionNotGranted = "notification permission not granted"
    case landedOnIntroScreen = "landed on intro screen"
    case landedOnLastStep = "landed on last step"
    case ctaTapped = "cta tapped" // source = intro screen, last step
    
    // MARK: Self affirmation
    case landedOnSelfAffirmationScreen = "landed on self affirmation screen"
    case selfAffirmationDownloaded = "self affirmation downloaded"
    case selfAffirmationSwiped = "self affirmation swiped"
    
    // MARK: Send love
    case landedOnSendLoveScreen = "landed on send love screen" // source = "tab, message received"
    case themeSelected = "theme selected"
    case generateAnotherTapped = "generate another tapped"
    case choicesOverPopupShown = "choices over popup shown"
    case lessOptionsPopupShown = "less options popup shown"
    case sharePressed = "share pressed"
    case pickFromContactsTapped = "pick from contacts tapped"
    case sendPressed = "send pressed"
    case landedOnSelectedTheme = "landed on selected theme"
    
    // MARK: Message received
    case landedOnMessageReceived = "landed on message received" // souce = "tab, deeplink"
    
    // MARK: Profile
    case landedOnProfileScreen = "landed on profile screen"
    case profileButtonTapped = "profile button tapped"
    case landedOnMeaningScreen = "landed on meaning screen"
    case shareAppPressed = "share app pressed"
    case logoutPressed = "logout pressed"
    case logoutConfirmed = "logout confirmed"
    case landedOnSettingsScreen = "landed on settings screen"
    case savePressed = "save pressed"
    case deleteTapped = "delete tapped"
    case deleteConfirmed = "delete confirmed"
    
    // MARK: Deeplink
    case landedFromBranchLink = "landed from branch link"
    
    // MARK: Notification
    case launchedFromNotification = "launched from notification"
    
}
