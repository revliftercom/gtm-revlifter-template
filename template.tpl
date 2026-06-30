___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_revlifter_tag",
  "version": 1,
  "securityGroups": [],
  "displayName": "RevLifter",
  "brand": {
    "id": "brand_revlifter",
    "displayName": "RevLifter"
  },
  "description": "Loads the RevLifter engine on your site. Enter your RevLifter Site UUID to initialise the loader and fire the \u0027load\u0027 command.",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "siteUuid",
    "displayName": "RevLifter Site UUID",
    "simpleValueType": true,
    "help": "Your unique RevLifter Site UUID. You can find this in your RevLifter dashboard. It is used to load https://assets.revlifter.io/[SITE_UUID].js and to fire the \u0027load\u0027 command.",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const createQueue = require('createQueue');
const injectScript = require('injectScript');
const setInWindow = require('setInWindow');
const encodeUriComponent = require('encodeUriComponent');

// The Site UUID entered by the user in the tag's field.
const uuid = data.siteUuid;

// Guard: if no UUID is supplied, fail gracefully so GTM doesn't hang.
if (!uuid) {
  data.gtmOnFailure();
  return;
}

// Build the loader URL. Encode the UUID to keep the injected URL well-formed.
const url = 'https://assets.revlifter.io/' + encodeUriComponent(uuid) + '.js';

// 1. Mirror: window.RevLifterObject = 'revlifter'
//    overwrite = false so we don't clobber an existing value on repeat fires.
setInWindow('RevLifterObject', 'revlifter', false);

// 2. Mirror: window.revlifter = function(){ (revlifter.q = revlifter.q || []).push(arguments) }
//    createQueue creates the global queue function and returns a callable handle.
const revlifter = createQueue('revlifter');

// 3. Mirror: revlifter('load', uuid)
revlifter('load', uuid);

// 4. Mirror: async injection of the loader script (a.async = 1; insertBefore).
//    The loader handles its own timing internally, so window.revlifter.l is
//    intentionally not set (the sandbox cannot set that nested property and the
//    loader does not require it).
injectScript(url, data.gtmOnSuccess, data.gtmOnFailure, url);


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://assets.revlifter.io/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "revlifter"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "RevLifterObject"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Injects loader with a valid UUID
  code: |-
    const mockData = {
      siteUuid: 'abc-123-uuid'
    };

    // injectScript should be called with the correctly built URL.
    mock('injectScript', (url, onSuccess, onFailure, cacheToken) => {
      assertThat(url).isEqualTo('https://assets.revlifter.io/abc-123-uuid.js');
      onSuccess();
    });

    runCode(mockData);

    assertApi('gtmOnSuccess').wasCalled();
    assertApi('gtmOnFailure').wasNotCalled();
- name: Sets the RevLifterObject global and creates the queue
  code: |-
    const mockData = {
      siteUuid: 'abc-123-uuid'
    };

    mock('injectScript', (url, onSuccess) => {
      onSuccess();
    });

    runCode(mockData);

    assertApi('setInWindow').wasCalled();
    assertApi('createQueue').wasCalled();
- name: Fails gracefully when UUID is missing
  code: |-
    const mockData = {
      siteUuid: ''
    };

    let injected = false;
    mock('injectScript', () => {
      injected = true;
    });

    runCode(mockData);

    assertThat(injected).isEqualTo(false);
    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();
- name: Calls gtmOnFailure when the script fails to load
  code: |-
    const mockData = {
      siteUuid: 'abc-123-uuid'
    };

    mock('injectScript', (url, onSuccess, onFailure) => {
      onFailure();
    });

    runCode(mockData);

    assertApi('gtmOnFailure').wasCalled();
    assertApi('gtmOnSuccess').wasNotCalled();


___NOTES___

Created on a development workstation for the RevLifter Community Template Gallery
submission. The template reproduces the official RevLifter on-page snippet:
  - window.RevLifterObject = 'revlifter'
  - window.revlifter command queue (pushes arguments to revlifter.q)
  - revlifter('load', [SITE_UUID])
  - async injection of https://assets.revlifter.io/[SITE_UUID].js

The original snippet's `window.revlifter.l = 1 * new Date()` timestamp is
intentionally omitted: the loader manages its own timing via the command-queue
pattern and does not read a pre-set `.l` value.


