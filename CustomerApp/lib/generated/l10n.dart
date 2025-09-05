// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome to Wasselha!`
  String get Welcome {
    return Intl.message(
      'Welcome to Wasselha!',
      name: 'Welcome',
      desc: '',
      args: [],
    );
  }

  /// `Order History`
  String get OrderHisT {
    return Intl.message(
      'Order History',
      name: 'OrderHisT',
      desc: '',
      args: [],
    );
  }

  /// `Active Orders`
  String get ActivOr {
    return Intl.message(
      'Active Orders',
      name: 'ActivOr',
      desc: '',
      args: [],
    );
  }

  /// `There is no active orders`
  String get NoActiveO {
    return Intl.message(
      'There is no active orders',
      name: 'NoActiveO',
      desc: '',
      args: [],
    );
  }

  /// `Past Orders`
  String get PastOrder {
    return Intl.message(
      'Past Orders',
      name: 'PastOrder',
      desc: '',
      args: [],
    );
  }

  /// `There is no past orders`
  String get NoPastOrd {
    return Intl.message(
      'There is no past orders',
      name: 'NoPastOrd',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get SettingsTitle {
    return Intl.message(
      'Settings',
      name: 'SettingsTitle',
      desc: '',
      args: [],
    );
  }

  /// `General`
  String get General {
    return Intl.message(
      'General',
      name: 'General',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get Language {
    return Intl.message(
      'Language',
      name: 'Language',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get Theme {
    return Intl.message(
      'Theme',
      name: 'Theme',
      desc: '',
      args: [],
    );
  }

  /// `Help & support`
  String get hs {
    return Intl.message(
      'Help & support',
      name: 'hs',
      desc: '',
      args: [],
    );
  }

  /// `About`
  String get about {
    return Intl.message(
      'About',
      name: 'about',
      desc: '',
      args: [],
    );
  }

  /// `Welcome Back!`
  String get WelcomeBack {
    return Intl.message(
      'Welcome Back!',
      name: 'WelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Buckle up! We’re on delivery duty`
  String get Duty {
    return Intl.message(
      'Buckle up! We’re on delivery duty',
      name: 'Duty',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get loginEmail {
    return Intl.message(
      'Email',
      name: 'loginEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get loginPassword {
    return Intl.message(
      'Password',
      name: 'loginPassword',
      desc: '',
      args: [],
    );
  }

  /// `Log in`
  String get Login {
    return Intl.message(
      'Log in',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get YdntHave {
    return Intl.message(
      'Don\'t have an account?',
      name: 'YdntHave',
      desc: '',
      args: [],
    );
  }

  /// `Sign up.`
  String get SignUp {
    return Intl.message(
      'Sign up.',
      name: 'SignUp',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get CreateAcc {
    return Intl.message(
      'Create account',
      name: 'CreateAcc',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get AlreHav {
    return Intl.message(
      'Already have an account?',
      name: 'AlreHav',
      desc: '',
      args: [],
    );
  }

  /// `Log in.`
  String get LogIn {
    return Intl.message(
      'Log in.',
      name: 'LogIn',
      desc: '',
      args: [],
    );
  }

  /// `Search the market`
  String get HPSearch {
    return Intl.message(
      'Search the market',
      name: 'HPSearch',
      desc: '',
      args: [],
    );
  }

  /// `Our Stores:`
  String get HPH1 {
    return Intl.message(
      'Our Stores:',
      name: 'HPH1',
      desc: '',
      args: [],
    );
  }

  /// `Selected Products:`
  String get HPH2 {
    return Intl.message(
      'Selected Products:',
      name: 'HPH2',
      desc: '',
      args: [],
    );
  }

  /// `Sales`
  String get HPH3 {
    return Intl.message(
      'Sales',
      name: 'HPH3',
      desc: '',
      args: [],
    );
  }

  /// `Add to cart`
  String get PDC {
    return Intl.message(
      'Add to cart',
      name: 'PDC',
      desc: '',
      args: [],
    );
  }

  /// `Add to favorites`
  String get PDF {
    return Intl.message(
      'Add to favorites',
      name: 'PDF',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get DrawerProflie {
    return Intl.message(
      'Profile',
      name: 'DrawerProflie',
      desc: '',
      args: [],
    );
  }

  /// `Cart`
  String get DrawerCart {
    return Intl.message(
      'Cart',
      name: 'DrawerCart',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get DrawerFav {
    return Intl.message(
      'Favorites',
      name: 'DrawerFav',
      desc: '',
      args: [],
    );
  }

  /// `History`
  String get DrawerHistory {
    return Intl.message(
      'History',
      name: 'DrawerHistory',
      desc: '',
      args: [],
    );
  }

  /// `Sttings`
  String get DrawerSet {
    return Intl.message(
      'Sttings',
      name: 'DrawerSet',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get SetTitle {
    return Intl.message(
      'Account Settings',
      name: 'SetTitle',
      desc: '',
      args: [],
    );
  }

  /// `First Name`
  String get SetFirstName {
    return Intl.message(
      'First Name',
      name: 'SetFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last Name`
  String get SetLastName {
    return Intl.message(
      'Last Name',
      name: 'SetLastName',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get SetEmail {
    return Intl.message(
      'Email',
      name: 'SetEmail',
      desc: '',
      args: [],
    );
  }

  /// `Birth Date`
  String get SetBD {
    return Intl.message(
      'Birth Date',
      name: 'SetBD',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get SetAdress {
    return Intl.message(
      'Address',
      name: 'SetAdress',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get SetGender {
    return Intl.message(
      'Gender',
      name: 'SetGender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get SetGenderM {
    return Intl.message(
      'Male',
      name: 'SetGenderM',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get SetGenderF {
    return Intl.message(
      'Female',
      name: 'SetGenderF',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get SetCity {
    return Intl.message(
      'City',
      name: 'SetCity',
      desc: '',
      args: [],
    );
  }

  /// `Aleppo`
  String get SetCityA {
    return Intl.message(
      'Aleppo',
      name: 'SetCityA',
      desc: '',
      args: [],
    );
  }

  /// `Damascus`
  String get SetCityD {
    return Intl.message(
      'Damascus',
      name: 'SetCityD',
      desc: '',
      args: [],
    );
  }

  /// `Homs`
  String get SetCityH {
    return Intl.message(
      'Homs',
      name: 'SetCityH',
      desc: '',
      args: [],
    );
  }

  /// `Latakia`
  String get SetCityL {
    return Intl.message(
      'Latakia',
      name: 'SetCityL',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get SetSave {
    return Intl.message(
      'Save',
      name: 'SetSave',
      desc: '',
      args: [],
    );
  }

  /// `Mobile Number`
  String get SetNumber {
    return Intl.message(
      'Mobile Number',
      name: 'SetNumber',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get SetPassword {
    return Intl.message(
      'Password',
      name: 'SetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get SetConfirmPassword {
    return Intl.message(
      'Confirm Password',
      name: 'SetConfirmPassword',
      desc: '',
      args: [],
    );
  }

  /// `Your Cart`
  String get CartTitle {
    return Intl.message(
      'Your Cart',
      name: 'CartTitle',
      desc: '',
      args: [],
    );
  }

  /// `You have `
  String get CartH {
    return Intl.message(
      'You have ',
      name: 'CartH',
      desc: '',
      args: [],
    );
  }

  /// ` item in your cart`
  String get CartH1 {
    return Intl.message(
      ' item in your cart',
      name: 'CartH1',
      desc: '',
      args: [],
    );
  }

  /// ` items in your cart`
  String get CartH2 {
    return Intl.message(
      ' items in your cart',
      name: 'CartH2',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get CartTotal {
    return Intl.message(
      'Total',
      name: 'CartTotal',
      desc: '',
      args: [],
    );
  }

  /// `VAT included`
  String get CartTax {
    return Intl.message(
      'VAT included',
      name: 'CartTax',
      desc: '',
      args: [],
    );
  }

  /// `Check out`
  String get CartCheck {
    return Intl.message(
      'Check out',
      name: 'CartCheck',
      desc: '',
      args: [],
    );
  }

  /// `Order Tracking`
  String get TrackingTitle {
    return Intl.message(
      'Order Tracking',
      name: 'TrackingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Order placed`
  String get TrackingPlaced {
    return Intl.message(
      'Order placed',
      name: 'TrackingPlaced',
      desc: '',
      args: [],
    );
  }

  /// `In the way`
  String get TrackingITW {
    return Intl.message(
      'In the way',
      name: 'TrackingITW',
      desc: '',
      args: [],
    );
  }

  /// `Deliverd`
  String get TrackingDone {
    return Intl.message(
      'Deliverd',
      name: 'TrackingDone',
      desc: '',
      args: [],
    );
  }

  /// `Order details`
  String get TrackingDetails {
    return Intl.message(
      'Order details',
      name: 'TrackingDetails',
      desc: '',
      args: [],
    );
  }

  /// `Favorites`
  String get FavTitle {
    return Intl.message(
      'Favorites',
      name: 'FavTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search the store`
  String get StoreSearch {
    return Intl.message(
      'Search the store',
      name: 'StoreSearch',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get Next {
    return Intl.message(
      'Next',
      name: 'Next',
      desc: '',
      args: [],
    );
  }

  /// `Previous`
  String get Previous {
    return Intl.message(
      'Previous',
      name: 'Previous',
      desc: '',
      args: [],
    );
  }

  /// `Checkout`
  String get Checkout {
    return Intl.message(
      'Checkout',
      name: 'Checkout',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Time`
  String get DeliveryTime {
    return Intl.message(
      'Delivery Time',
      name: 'DeliveryTime',
      desc: '',
      args: [],
    );
  }

  /// `ASAP`
  String get ASAP {
    return Intl.message(
      'ASAP',
      name: 'ASAP',
      desc: '',
      args: [],
    );
  }

  /// `Scheduled Order`
  String get Schd {
    return Intl.message(
      'Scheduled Order',
      name: 'Schd',
      desc: '',
      args: [],
    );
  }

  /// `My Addresses`
  String get MyAD {
    return Intl.message(
      'My Addresses',
      name: 'MyAD',
      desc: '',
      args: [],
    );
  }

  /// `Add Address Details`
  String get AddressDetails {
    return Intl.message(
      'Add Address Details',
      name: 'AddressDetails',
      desc: '',
      args: [],
    );
  }

  /// `Pay With`
  String get PayWith {
    return Intl.message(
      'Pay With',
      name: 'PayWith',
      desc: '',
      args: [],
    );
  }

  /// `Delivery Fee`
  String get DeliveryFee {
    return Intl.message(
      'Delivery Fee',
      name: 'DeliveryFee',
      desc: '',
      args: [],
    );
  }

  /// `Final Price`
  String get fp {
    return Intl.message(
      'Final Price',
      name: 'fp',
      desc: '',
      args: [],
    );
  }

  /// `Payment Successful`
  String get PAS {
    return Intl.message(
      'Payment Successful',
      name: 'PAS',
      desc: '',
      args: [],
    );
  }

  /// `Your order has been placed`
  String get Oplaced {
    return Intl.message(
      'Your order has been placed',
      name: 'Oplaced',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get OK {
    return Intl.message(
      'OK',
      name: 'OK',
      desc: '',
      args: [],
    );
  }

  /// `Place Order`
  String get PlaceOrder {
    return Intl.message(
      'Place Order',
      name: 'PlaceOrder',
      desc: '',
      args: [],
    );
  }

  /// `Log Out`
  String get logout {
    return Intl.message(
      'Log Out',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get loginphone {
    return Intl.message(
      'Phone Number',
      name: 'loginphone',
      desc: '',
      args: [],
    );
  }

  /// `Log in with email`
  String get LoginWemail {
    return Intl.message(
      'Log in with email',
      name: 'LoginWemail',
      desc: '',
      args: [],
    );
  }

  /// `Log in with phone number`
  String get LoginWphone {
    return Intl.message(
      'Log in with phone number',
      name: 'LoginWphone',
      desc: '',
      args: [],
    );
  }

  /// `Please use a valid email.`
  String get NotVEmail {
    return Intl.message(
      'Please use a valid email.',
      name: 'NotVEmail',
      desc: '',
      args: [],
    );
  }

  /// `Weak password.`
  String get NotVPass {
    return Intl.message(
      'Weak password.',
      name: 'NotVPass',
      desc: '',
      args: [],
    );
  }

  /// `Passwords does not match.`
  String get NotMatch {
    return Intl.message(
      'Passwords does not match.',
      name: 'NotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Not a name.`
  String get NotVName {
    return Intl.message(
      'Not a name.',
      name: 'NotVName',
      desc: '',
      args: [],
    );
  }

  /// `Address cannot be empty.`
  String get NotVAddress {
    return Intl.message(
      'Address cannot be empty.',
      name: 'NotVAddress',
      desc: '',
      args: [],
    );
  }

  /// `YYYY/MM/DD`
  String get NotVBD {
    return Intl.message(
      'YYYY/MM/DD',
      name: 'NotVBD',
      desc: '',
      args: [],
    );
  }

  /// `Please fill in all fields.`
  String get fillAll {
    return Intl.message(
      'Please fill in all fields.',
      name: 'fillAll',
      desc: '',
      args: [],
    );
  }

  /// `Privacy`
  String get privacy {
    return Intl.message(
      'Privacy',
      name: 'privacy',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get Passwordch {
    return Intl.message(
      'Change Password',
      name: 'Passwordch',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get changeTitle {
    return Intl.message(
      'Change Password',
      name: 'changeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Current Password.`
  String get CurrentPassword {
    return Intl.message(
      'Current Password.',
      name: 'CurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your current password`
  String get PleaseE {
    return Intl.message(
      'Please enter your current password',
      name: 'PleaseE',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get NewPassword {
    return Intl.message(
      'New Password',
      name: 'NewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a new password.`
  String get PleaseEtn {
    return Intl.message(
      'Please enter a new password.',
      name: 'PleaseEtn',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters`
  String get Password6LETTER {
    return Intl.message(
      'Password must be at least 6 characters',
      name: 'Password6LETTER',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get ConfirmNewPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'ConfirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Please confirm your new password`
  String get Pleaseconfirmyournewpassword {
    return Intl.message(
      'Please confirm your new password',
      name: 'Pleaseconfirmyournewpassword',
      desc: '',
      args: [],
    );
  }

  /// `Passwords do not match.`
  String get Passwordsdonotmatch {
    return Intl.message(
      'Passwords do not match.',
      name: 'Passwordsdonotmatch',
      desc: '',
      args: [],
    );
  }

  /// `Change Password`
  String get ChangePassword {
    return Intl.message(
      'Change Password',
      name: 'ChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get SetNewPassword {
    return Intl.message(
      'New Password',
      name: 'SetNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New Password`
  String get SeTConfPassword {
    return Intl.message(
      'Confirm New Password',
      name: 'SeTConfPassword',
      desc: '',
      args: [],
    );
  }

  /// `Old Password`
  String get SetOldPassword {
    return Intl.message(
      'Old Password',
      name: 'SetOldPassword',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
