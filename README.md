# Shopify Script Examples

Some examples to get you started on Shopify Scripts. You must be a Shopify Plus merchant to get access to the Script Editor.
More info here: https://help.shopify.com/manual/apps/apps-by-shopify/script-editor

Each `.rb` file is a different script. To use one, copy the code, create a new script on the Script Editor app, paste the code on Ruby source code editor, and edit variables.


## Variables:
A campaign is initiated at the end of the code, and you need to edit each variable for discount, the ID of the products it will be applied to, and the message.
Here's an example:

```
prodA = 118060358
prodB = 118028404
discX = 50
message = "Buy Cloaking Device and Get 50% OFF on Ultimate Nullifier"

# List of campaigns.
CAMPAIGNS = [
    BuyAGetBXOffCampaign.new(
        ProductsSelector.new(prodA),
        ProductsSelector.new(prodB),
        PercentageDiscount.new(discX, message)
    )
]
```

## Inquiries
Any questions, let us know at: support@pasilobus.com.
Please report bugs by filing a new issue.

Learn more about Pasilobus at our website https://www.pasilobus.com
