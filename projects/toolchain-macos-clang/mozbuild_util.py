# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this file,
# You can obtain one at http://mozilla.org/MPL/2.0/.

# This file includes the only utility we actually need from
# python/mozbuild/mozbuild/util.py in Firefox's source code.


class ReadOnlyNamespace(object):
    """A class for objects with immutable attributes set at initialization."""

    def __init__(self, **kwargs):
        for k, v in kwargs.items():
            super(ReadOnlyNamespace, self).__setattr__(k, v)

    def __delattr__(self, key):
        raise Exception("Object does not support deletion.")

    def __setattr__(self, key, value):
        raise Exception("Object does not support assignment.")

    def __ne__(self, other):
        return not (self == other)

    def __eq__(self, other):
        return self is other or (
            hasattr(other, "__dict__") and self.__dict__ == other.__dict__
        )

    def __repr__(self):
        return "<%s %r>" % (self.__class__.__name__, self.__dict__)
