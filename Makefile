##
# Copyright 2010 Charles Y. Choi, Yummy Melon Software LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##
# This file will check out the Objective-C component of OAuthConsumer and
# package it into a directory named OAuthConsumer that can be imported
# (by reference or directly copied) into an iPhone XCode project.
#
# Override the variable PREFIX (default is the current directory) to relocate
# OAuthConsumer into different base directory.

PREFIX=.
OAUTH_DISTRIB_SRC=http://oauth.googlecode.com/svn/code/obj-c
OAUTH_DISTRIB_TGT=oauth-objc
INCLUDE_FILES:=OAAsynchronousDataFetcher.h \
OAConsumer.h \
OADataFetcher.h \
OAHMAC_SHA1SignatureProvider.h \
OAMutableURLRequest.h \
OAPlaintextSignatureProvider.h \
OARequestParameter.h \
OAServiceTicket.h \
OAToken.h \
NSMutableURLRequest+Parameters.h \
NSString+URLEncoding.h \
NSURL+Base.h \
OAuthConsumer.h \
OASignatureProviding.h


IMPLEMENTATION_FILES:=OAAsynchronousDataFetcher.m \
OAConsumer.m \
OADataFetcher.m \
OAHMAC_SHA1SignatureProvider.m \
OAMutableURLRequest.m \
OAPlaintextSignatureProvider.m \
OARequestParameter.m \
OAServiceTicket.m \
OAToken.m \
NSMutableURLRequest+Parameters.m \
NSString+URLEncoding.m \
NSURL+Base.m

CRYPTO_FILES:=Base64Transcoder.c Base64Transcoder.h
TARGET_NAME=OAuthConsumer
TARGET_DIR=${PREFIX}/${TARGET_NAME}


distrib: ${OAUTH_DISTRIB_TGT} ${TARGET_DIR} ${INCLUDE_FILES} ${IMPLEMENTATION_FILES} ${CRYPTO_FILES}

${OAUTH_DISTRIB_TGT}:
	svn checkout ${OAUTH_DISTRIB_SRC} ${OAUTH_DISTRIB_TGT}
	mkdir -p ${TARGET_DIR}/Crypto


${INCLUDE_FILES} ${IMPLEMENTATION_FILES}:
	cp ${OAUTH_DISTRIB_TGT}/${TARGET_NAME}/$@ ${PREFIX}/${TARGET_NAME}

${CRYPTO_FILES}:
	cp ${OAUTH_DISTRIB_TGT}/${TARGET_NAME}/Crypto/$@ ${PREFIX}/${TARGET_NAME}/Crypto

clean:
	rm -rf ${OAUTH_DISTRIB_TGT}

cleanall: clean
	rm -rf ${TARGET_DIR}
