/**
 * Copyright 2021 Start.io Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "StartioMAXNativeAdapter.h"
#import "StartioMAXAdapterError.h"
#import "StartioMAXNativeAd.h"
#import "StartioMAXExtras.h"
#import <StartApp/StartApp.h>

@interface StartioMAXNativeAdapter()<STADelegateProtocol>
@property (nonatomic, strong) STAStartAppNativeAd *nativeAd;
@property (nonatomic, strong) StartioMAXNativeAd *adapterNativeAd;
@property (nonatomic, weak) id<MANativeAdAdapterDelegate> delegate;
@end

@implementation StartioMAXNativeAdapter
- (void)loadNativeAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MANativeAdAdapterDelegate>)delegate {
    StartioMAXExtras *extras = [[StartioMAXExtras alloc] initWithParamsDictionary:parameters.customParameters];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.delegate = delegate;
        self.nativeAd = [[STAStartAppNativeAd alloc] init];
        STANativeAdPreferences *nativeAdPrefs = extras.prefs;
        nativeAdPrefs.adsNumber = 1;
        nativeAdPrefs.autoBitmapDownload = YES;
        [self.nativeAd loadAdWithDelegate:self withNativeAdPreferences:nativeAdPrefs];
    });
}

- (MANativeAd *)maNativeAdFromSTANativeAdDetails:(STANativeAdDetails *)nativeAdDetails {
    if (nativeAdDetails) {
        self.adapterNativeAd = [[StartioMAXNativeAd alloc] initWithSTANAtiveAdDetails:nativeAdDetails];
        return self.adapterNativeAd;
    }
    return nil;
}

- (void)didLoadAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didLoadAdForNativeAd:withExtraInfo:)]) {
        [self.delegate didLoadAdForNativeAd:[self maNativeAdFromSTANativeAdDetails:self.nativeAd.adsDetails.firstObject] withExtraInfo:nil];
    }
}

- (void)failedLoadAd:(STAAbstractAd *)ad withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFailToLoadNativeAdWithError:)]) {
        [self.delegate didFailToLoadNativeAdWithError:[StartioMAXAdapterError maAdapterErrorFromSTAError:error]];
    }
}

- (void)didSendImpressionForNativeAdDetails:(STANativeAdDetails *)nativeAdDetails {
    if ([self.delegate respondsToSelector:@selector(didDisplayNativeAdWithExtraInfo:)]) {
        [self.delegate didDisplayNativeAdWithExtraInfo:nil];
    }
}

- (void)didClickNativeAdDetails:(STANativeAdDetails *)nativeAdDetails {
    if ([self.delegate respondsToSelector:@selector(didClickNativeAd)]) {
        [self.delegate didClickNativeAd];
    }
}

@end
