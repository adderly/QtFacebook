/* ************************************************************************
 * Copyright (c) 2014 GMaxera <gmaxera@gmail.com>                         *
 *                                                                        *
 * This file is part of QtFacebook                                        *
 *                                                                        *
 * QtFacebook is free software: you can redistribute it and/or modify     *
 * it under the terms of the GNU General Public License as published by   *
 * the Free Software Foundation, either version 3 of the License, or      *
 * (at your option) any later version.                                    *
 *                                                                        *
 * This program is distributed in the hope that it will be useful,        *
 * but WITHOUT ANY WARRANTY; without even the implied warranty of         *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.                   *
 * See the GNU General Public License for more details.                   *
 *                                                                        *
 * You should have received a copy of the GNU General Public License      *
 * along with this program. If not, see <http://www.gnu.org/licenses/>.   *
 * ********************************************************************** */
#ifdef  QFACEBOOK_SDK_4
#include "qfacebook.h"
//#import "FacebookSDK/FacebookSDK.h"
#import "UIKit/UIKit.h"
#include <FBSDKCoreKit/FBSDKCoreKit.h>
#include <QString>
#include <QPixmap>
#include <QByteArray>
#include <QBuffer>

#ifndef QFACEBOOK_NOT_DEFINE_IOS_URL_HANDLER
/*! Override the application:openURL UIApplicationDelegate adding
 *  a category to the QIOApplicationDelegate.
 *  The only way to do that even if it's a bit like hacking the Qt stuff
 *  See: https://bugreports.qt-project.org/browse/QTBUG-38184
 */
@interface QIOSApplicationDelegate
@end
//! Add a category to QIOSApplicationDelegate
@interface QIOSApplicationDelegate (QFacebookApplicationDelegate)
@end
//! Now add method for handling the openURL from Facebook Login
@implementation QIOSApplicationDelegate (QFacebookApplicationDelegate)
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString*) sourceApplication annotation:(id)annotation {
#pragma unused(application)
#pragma unused(sourceApplication)
#pragma unused(annotation)
    NSLog(@"error:%@",@"Facebook handled url");
    return [[FBSession activeSession] handleOpenURL:url];
}
@end
#endif

using namespace sdkbox;


class QFacebookPlatformData {
public:
    QFacebook* qFacebook;
//    void sessionStateHandler(FBSession* session, FBSessionState fstate, NSError* error) {
//        if (error) {
//            NSLog(@"error:%@",error);
//        }
//        QStringList grantedList;
//        switch( fstate ) {
//        case FBSessionStateCreated:
//            qFacebook->onFacebookStateChanged( QFacebook::SessionCreated, QStringList() );
//            break;
//        case FBSessionStateCreatedTokenLoaded:
//            qFacebook->onFacebookStateChanged( QFacebook::SessionCreatedTokenLoaded, QStringList() );
//            break;
//        case FBSessionStateCreatedOpening:
//            qFacebook->onFacebookStateChanged( QFacebook::SessionCreatedTokenLoaded, QStringList() );
//            break;
//        case FBSessionStateOpen:
//            for( NSString* perm in [session permissions] ) {
//                grantedList.append( QString::fromNSString(perm) );
//            }
//            qFacebook->onFacebookStateChanged( QFacebook::SessionOpen, grantedList );
//            break;
//        case FBSSDKessionStateOpenTokenExtended:
//            for( NSString* perm in [session permissions] ) {
//                grantedList.append( QString::fromNSString(perm) );
//            }
//            qFacebook->onFacebookStateChanged( QFacebook::SessionOpenTokenExtended, grantedList );
//            break;
//        case FBSessionStateClosedLoginFailed:
//            qFacebook->onFacebookStateChanged( QFacebook::SessionClosedLoginFailed, QStringList() );
//            break;
//        case FBSessionStateClosed:
//            qFacebook->onFacebookStateChanged( QFacebook::SessionClosed, QStringList() );
//            break;
//        }
//    }
    //! subset of requestPermissions that only allow reading from Facebook
    NSMutableArray* readPermissions;
    //! subset of requestPermissions that allow writing to Facebook
    NSMutableArray* writePermissions;
};

void QFacebook::initPlatformData() {
    appID =  QString::fromNSString([FBSDKSettings appID]);
    displayName = QString::fromNSString( [FBSDKSettings displayName] );
    data = new QFacebookPlatformData();
    data->qFacebook = this;
    data->readPermissions = [[NSMutableArray alloc] init];
    data->writePermissions = [[NSMutableArray alloc] init];
    PluginFacebook::setListener(this);
    
//    [[FBSession activeSession]
//            setStateChangeHandler:^(FBSession* session, FBSessionState state, NSError* error) {
//                data->sessionStateHandler(session, state, error);
//    }];
//    data->sessionStateHandler( [FBSession activeSession], [[FBSession activeSession] state], NULL );
}

void QFacebook::login() {
    PluginFacebook::login();
}

bool QFacebook::autoLogin() {
    std::vector<std::string> v = {"public_profile", "user_friends", "email" };
    PluginFacebook::login(v);
    return false;
}

void QFacebook::close() {
    PluginFacebook::logout();
}

void QFacebook::requestMe() {

}

void QFacebook::requestPublishPermissions() {
   sdkbox::PluginFacebook::requestPublishPermissions({FB_PERM_PUBLISH_POST});
}

void QFacebook::publishPhoto(QString photoUrl, QString message) {
    sdkbox::FBShareInfo info;
    info.type  = sdkbox::FB_PHOTO;
    info.title = message.toStdString();
    info.image = photoUrl.toStdString();
    sdkbox::PluginFacebook::share(info);
}

void QFacebook::publishPhoto( QPixmap photo, QString message ) {
  
}

void QFacebook::publishPhotosViaShareDialog(QVariantList photos)
{
    qDebug() << "Publish Photos" << photos.size();
}

void QFacebook::publishPhotoViaShareDialog(QString photo_url, QString caption) {


}

void QFacebook::publishLinkViaShareDialog( QString linkName, QString link, QString imageUrl, QString caption, QString description ) {
}

void QFacebook::requestMyFriends() {
    // Issue a Facebook Graph API request to get your user's friend list
    PluginFacebook::fetchFriends();
}

void QFacebook::inviteFriends(QString appId,QString imgUrl){
    PluginFacebook::inviteFriends(appId.toStdString(), imgUrl.toStdString());
}

void QFacebook::setAppID( QString appID ) {
    if ( this->appID != appID ) {
        this->appID = appID;
//        [FBSDKSettings setDefaultAppID:(this->appID.toNSString())];
        emit appIDChanged( this->appID );
    }
}

void QFacebook::setDisplayName( QString displayName ) {
    if ( this->displayName != displayName ) {
        this->displayName = displayName;
//        [FBSettings setDefaultDisplayName:(this->displayName.toNSString())];
        emit displayNameChanged( this->displayName );
    }
}

void QFacebook::setRequestPermissions( QStringList requestPermissions ) {
    this->requestPermissions = requestPermissions;
    emit requestPermissionsChanged( this->requestPermissions );
}

void QFacebook::addRequestPermission( QString requestPermission ) {
    if ( !requestPermissions.contains(requestPermission) ) {
        // add the permission
        requestPermissions.append( requestPermission );
        emit requestPermissionsChanged(requestPermissions);
    }
}

QString QFacebook::getAccessToken() {
    return QString::fromStdString(PluginFacebook::getAccessToken());
}

QString QFacebook::getExpirationDate() {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale* enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];

    NSDate* date = [[FBSDKAccessToken currentAccessToken] expirationDate] ;
    
    return QString::fromNSString( [dateFormatter stringFromDate:date] );
}

void QFacebook::onApplicationStateChanged(Qt::ApplicationState state) {
//    if ( state == Qt::ApplicationActive ) {
//        [[FBSession activeSession] handleDidBecomeActive];
//    }
}

#endif
