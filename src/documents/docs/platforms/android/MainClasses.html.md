---
layout: "content"
image: "Tutorial"
title: "Main Classes"
text: "The main classes of android-store contain functionality to perform store-related operations, provide you with different storages, and hold the basic assets needed to operate the store."
position: 4
theme: 'platforms'
collection: 'platforms_android'
---

#**Main Classes**

Here you can find descriptions of some of the main classes and interfaces of android-store. These classes contain functionality to perform store-related operations, provide you with different storages, and hold the basic assets needed to operate the store.

##[StoreController](https://github.com/soomla/android-store/blob/master/SoomlaAndroidStore/src/com/soomla/store/StoreController.java)

StoreController holds the basic assets needed to operate the Store. You can use it to purchase products from the Market. It provides you with functionality such as querying the inventory for information, and starting a purchase process with the market (Google Play, Amazon App Store, etc…).

> **NOTE:** This is the only class you need to initialize in order to use the SOOMLA SDK. More about this in [Getting Started](/docs/platforms/android/soomla/GettingStarted).

Taken from StoreExampleActivity.java of our Muffin Rush [Example](https://github.com/soomla/android-store/tree/master/SoomlaAndroidExample/src/com/soomla/example).

``` java
IStoreAssets storeAssets = new MuffinRushAssets();
StoreController.getInstance().initialize(storeAssets,
    "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAphC8H7OYag8u8l1WayR7dHMKFC+XC09tLk9A"
    + "6FnxqsJPF4+Y4iJ4NTs24PVYWB4y/DQjfo3b7z6DqXBYgAOMYn7I3VIbjzgbit+DgGWfmiKWCQotcG"
    + "5jWEsTiGMy+yRkJ6mwvWyVt8c3EfYrgrIfDMYrzIpk+F0PK/ybDiQmj4j2H9PB3NwOMpaGCkKM3IrE"
    + "Y66fclnJpO3nDqN7Lun5mGAlni5eMKkwM5f5O8DUD65y/MmXTwUddXKnIaurY6giRcJktK6zWsFopx"
    + "f2EzDb1byP3ISiwxZAgic5BfQYh3HAbeEMD0CvRCHQIctJ8k7zn63NmaemPR7lFjY1GNWeowIDAQAB",
    "aaaaabbbbbb");
```
<br>
###Important Functions

**`public void refreshInventory(final boolean refreshMarketItemsDetails)`**

This function queries the Market’s inventory, and creates a list of all metadata stored in the Market (the items that have been purchased). The metadata includes the item's name, description, price, product ID, etc… Then a `MarketItemsRefreshed` event is posted with the list just created. Upon failure, an error message is printed.

##[StoreInfo](https://github.com/soomla/android-store/blob/master/SoomlaAndroidStore/src/com/soomla/store/data/StoreInfo.java)

`StoreInfo` is the mother of all metadata information about your specific game.

This class holds your store's

- Virtual currencies
- Virtual currency packs
- Virtual goods of all kinds
- Virtual categories
- Non-consumable items

`StoreInfo` can be questioned about the existence of `VirtualItem`s and the associations between them.

`StoreInfo` is always initialized from the database, except for the first time the game is loaded - in that case it is initialized with your implementation of `IStoreAssets`, a class that represents your game's metadata. When your game loads for the first time, the virtual economy's metadata is saved, and from that moment on it'll be loaded from the database.

**Example:**

Get the current balance of a virtual good with item id "green_hat" (This is the long way, you should actually use `StoreInventory`'s functions.):

``` java
VirtualGood greenHat = (VirtualGood)StoreInfo.getVirtualItem("green_hat");
int greenHatsBalance = StorageManager.getVirtualGoodsStorage().getBalance(greenHat);
```
##[StorageManager](https://github.com/soomla/android-store/blob/master/SoomlaAndroidStore/src/com/soomla/store/data/StorageManager.java)

`StorageManager` creates all the storage-related instances in your game. These include: `VirtualCurrencyStorage`, `VirtualGoodsStorage`, `NonConsumableItemsStorage`, and `KeyValueStorage`.

Use the `StorageManager`’s static functions to access the different storage bases. Then you will be able to use the different storages’ available functions to perform actions such as set/get an item’s balance, add/remove an item from the storage, etc…

**Example:**

``` java
StorageManager.getNonConsumableItemsStorage().add(nonConsumableItem);
```

##[StoreInventory](https://github.com/soomla/android-store/blob/master/SoomlaAndroidStore/src/com/soomla/store/StoreInventory.java)

`StoreInventory` is a utility class that provides you with functions that perform store-related operations. With `StoreInventory` you can give or take items from your users. You can buy items or upgrade them. You can also check their equipping status and change it.

###Important Functions

**`buy(String itemId)`**

Buys the item that has the given itemId according to its purchase type - either with real money ($$$) or with other virtual items. Read more about PurchaseTypes in [Economy Model](/docs/platforms/android/soomla/EconomyModel).

**Example:** Buy a virtual item with `itemId` "blue_hat":

``` java
StoreInventory.buy("blue_hat");
```

<br>
**`giveVirtualItem(String itemId, int amount)`**

Gives your user the given amount of the virtual item with the given item ID, and gets nothing in return. For example, when your user plays your game for the first time you can GIVE him 1000 free gems to start out with.

**Example:** Give the user 10 pieces of a virtual currency with `itemId` "currency_coin":

``` java
StoreInventory.giveVirtualItem("currency_coin", 10);
```

<br>
**`takeVirtualItem(String itemId, int amount)`**

Takes from your user the given amount of the virtual item with the given item ID. For example, when your user requests a refund you TAKE the item he/she is returning.

**Example:**  Take 1 virtual good with `itemId` "green_hat":
``` java
StoreInventory.takeVirtualItem("green_hat", 1);
```


##[StoreConfig](https://github.com/soomla/android-store/blob/master/SoomlaAndroidStore/src/com/soomla/store/StoreConfig.java)

The configurations of your store will be kept in `StoreConfig`.

###`StoreConfig`’s configurations explained:

* **SOOM_SEC** - The main encryption secret. CHANGE IT! and change it only once.

* **logDebug** - Tells android-store if it needs to print debug messages or not.

* **friendlyRefunds** - A friendlyRefunds tells android-store if to let your refunded users keep their VirtualItems after a refund or not (default: false).

* **obfuscationSalt** - The obfuscated salt is an array randomly generated numbers. It's recommended that you change these numbers for your specific application, but change them only once!

* **DB_DELETE** - If this is true then the database will be deleted whenever the application loads.

    > **WARNING:** Do not release your game with this option set to true! Otherwise, your users will lose all their data every time they load the application.

    This feature can be useful for testing when you want to change stuff in your implementation of `IStoreAssets` and see the changes. If you try to change things in `IStoreAssets` and don't delete the DB then your changes will not be shown.

* **METADATA_VERSION** - Never change this value!