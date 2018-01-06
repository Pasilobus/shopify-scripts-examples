# Shopify Script Examples

Some examples to get you started on Shopify Scripts. You must be a Shopify Plus merchant to get access to the Script Editor.
More info here: https://help.shopify.com/manual/apps/apps-by-shopify/script-editor

Each .rb file is a different script. To use one, copy the code, create a new script on the Script Editor app, paste the code on Ruby source code editor, and edit variables.


## Variables:
A campaign is initiated at the end of the code, and you need to edit each variable for discount and the products it will be applied to.
Here's an example:

```
prodA = 118060358
prodB = 118028404
discX = 50

# List of campaigns.
CAMPAIGNS = [
    BuyAGetBXOffCampaign.new(
        ProductsSelector.new(118060358),
        ProductsSelector.new(118028404),
        PercentageDiscount.new(qtyX, "Buy Gaby Crumb Board and Get 50% OFF on Stainless Bread Knife")
    )
]
```
