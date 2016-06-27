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
#include <QString>
#include <QPixmap>
#include <QByteArray>
#include <QBuffer>

using namespace sdkbox;

void QFacebook::initPlatformData() {
    PluginFacebook::setListener(this);
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
        emit appIDChanged( this->appID );
    }
}

void QFacebook::setDisplayName( QString displayName ) {
    if ( this->displayName != displayName ) {
        this->displayName = displayName;
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
    sdkbox::PluginFacebook::

    return QString::fromNSString( [dateFormatter stringFromDate:date] );
}

void QFacebook::onApplicationStateChanged(Qt::ApplicationState state) {
}

#endif
