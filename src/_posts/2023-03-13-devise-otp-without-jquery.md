---
layout: post
title: "Devise-OTP without jQuery"
date: 2023-03-13 12-01-33
description: "Generate devise OTP (2fa) without needing jQuery for the QRcode generation"
tags: [devise, opt, rails, 2fa]
comments: false
---

Ruby/Rails boasts a unique diversity of available libraries and gems, including several options for authentication such as [Devise](https://github.com/heartcombo/devise), [omniauth](https://github.com/omniauth/omniauth), [clearance](https://github.com/thoughtbot/clearance), [sorcery](https://github.com/sorcery/sorcery), [rodauth](https://github.com/jeremyevans/rodauth), among others. While there are many options to choose from, I personally prefers Devise for its modularity and ease of use.

However, any modern application needs more than just an authentication system; you also want to ensure you build on permissions permissions _(for authorization)_, 2FA, and a solid hash library for additional secure measures.

There are several [2fa](https://en.wikipedia.org/wiki/Multi-factor_authentication) libraries that you can integrate with Devise, such as [devise-two-factor](https://github.com/tinfoil/devise-two-factor), [devise-otp](https://github.com/wmlele/devise-otp), [devise-2fa](https://github.com/williamatodd/devise-2fahttps://github.com/williamatodd/devise-2fa), [two_factor_authentication](https://github.com/Houdini/two_factor_authentication), among others. I honestly prefer [Devise-OTP](https://github.com/wmlele/devise-otp) for its ease of use and adherence to [RFC 6238](https://datatracker.ietf.org/doc/html/rfc6238) implementation using the  [ROTP](https://github.com/mdp/rotp) gem.

 However I did encounter an issue with Devise-OTP in that it still assumes applications using it are using Sprockets and jQuery, and the [qrcode JS](https://github.com/wmlele/devise-otp/blob/master/app/assets/javascripts/qrcode.js) file it includes requires jQuery. While I still use jQuery regularly at work, I have moved to using StimulusJS for personal projects.

After attempting to use several npm packages _(like [node-qrcode](https://github.com/soldair/node-qrcode))_ for generating the users 2fa QRcodes, I also found that 1Password had issues when scanning for a valid 2FA QR code; which could be a significant concern for many users. It is noted that the gem has a handy [helper](https://github.com/wmlele/devise-otp/blob/master/lib/devise_otp_authenticatable/controllers/helpers.rb#L148) `otp_authenticator_token_image_google` for generating QR codes using the Google Chart API, but generating QR codes with a third party like Google may not be the most security-conscious decision.

![qrcode](/images/posts/devise_otp_without_query/qrcode.png){: .img-fluid .w-3/12  }

After some playing around I was able to find an alternative method to get the qrcodes genreted in the application and without requiring jQuery to be included.

First to modify devise-opts views I ran the generator so they would be in the app, rather than in the gem.

`rails g devise_otp:views`

Next I added the follow gems to my Gemfile and bundled

```ruby
gem 'rotp'
gem 'rqrcode'
```

In my users helper I added the following method to generate the users 2fa QRcode

```ruby
def otp_rqr_image(otp_url)
  qr_code = RQRCode::QRCode
            .new(otp_url)
            .as_png(resize_exactly_to: 300)
            .to_data_url
  image_tag(qr_code)
end
```

Now within the view files that the gem generated you should have `app/views/devise/otp_tokens/_token_secret.html.slim`. This [file](https://github.com/wmlele/devise-otp/blob/master/app/views/devise/otp_tokens/_token_secret.html.erb#L4) is where the qrcode is generated for the user enabling 2fa for their account. I replaced the `otp_authenticator_token_image` (jQuery based) method with `otp_rqr_image` that we created earlier. You should now have a valid 2fa QRcode which is also scanable by 1Password and most of password managers or 2fa authenticators.

![qrcode](/images/posts/devise_otp_without_query/2fa_user_qrcode.png){: .img-fluid .w-4/5  }
