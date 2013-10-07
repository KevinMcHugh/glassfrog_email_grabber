USAGE

```
bundle install
export GLASSFROG_KEY=$YOUR_GLASSFROG_KEY
ruby get_emails.rb "$CIRCLE_NAME_YOU_CARE_ABOUT"
# Usually that's the name, sometimes there's a different name in italicized parens. 
# or "Faciliators", "Lead Links", "Rep Links", or "Secretaries", that works too.
- or -
ruby compose.rb "$CIRCLE_NAME_YOU_CARE_ABOUT", if you are on a Mac with Outlook
```

I didn't really test this
