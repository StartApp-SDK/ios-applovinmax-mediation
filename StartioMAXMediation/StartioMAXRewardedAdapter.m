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

#import "StartioMAXRewardedAdapter.h"
#import "StartioMAXAdapterError.h"
#import "StartioMAXExtras.h"
#import <StartApp/StartApp.h>

@interface StartioMAXRewardedAdapter()<STADelegateProtocol>
@property (nonatomic, strong) STAStartAppAd *rewardedAd;
@property (nonatomic, weak) id<MARewardedAdapterDelegate> delegate;
@end

@implementation StartioMAXRewardedAdapter
- (void)loadRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate {
    StartioMAXExtras *extras = [[StartioMAXExtras alloc] initWithParamsDictionary:parameters.customParameters];
    self.delegate = delegate;
    self.rewardedAd = [[STAStartAppAd alloc] init];
    [self.rewardedAd loadRewardedVideoAdWithDelegate:self withAdPreferences:extras.prefs];
}

- (void)showRewardedAdForParameters:(id<MAAdapterResponseParameters>)parameters andNotify:(id<MARewardedAdapterDelegate>)delegate {
    self.delegate = delegate;
    [self.rewardedAd showAd];
}


- (void)didLoadAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didLoadRewardedAd)]) {
        [self.delegate didLoadRewardedAd];
    }
}

- (void)failedLoadAd:(STAAbstractAd *)ad withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFailToLoadRewardedAdWithError:)]) {
        [self.delegate didFailToLoadRewardedAdWithError:[StartioMAXAdapterError maAdapterErrorFromSTAError:error]];
    }
}

- (void)didShowAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didDisplayRewardedAd)]) {
        [self.delegate didDisplayRewardedAd];
    }
    if ([self.delegate respondsToSelector:@selector(didStartRewardedAdVideo)]) {
        [self.delegate didStartRewardedAdVideo];
    }
}

- (void)failedShowAd:(STAAbstractAd *)ad withError:(NSError *)error {
    if ([self.delegate respondsToSelector:@selector(didFailToDisplayRewardedAdWithError:)]) {
        [self.delegate didFailToDisplayRewardedAdWithError:[StartioMAXAdapterError maAdapterErrorFromSTAError:error]];
    }
}

- (void)didCompleteVideo:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didCompleteRewardedAdVideo)]) {
        [self.delegate didCompleteRewardedAdVideo];
    }
    if ([self.delegate respondsToSelector:@selector(didRewardUserWithReward:)]) {
        [self.delegate didRewardUserWithReward:[MAReward rewardWithAmount:MAReward.defaultAmount label:MAReward.defaultLabel]];
    }
}

- (void)didClickAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didClickRewardedAd)]) {
        [self.delegate didClickRewardedAd];
    }
}

- (void)didCloseAd:(STAAbstractAd *)ad {
    if ([self.delegate respondsToSelector:@selector(didHideRewardedAd)]) {
        [self.delegate didHideRewardedAd];
    }
}
@end
