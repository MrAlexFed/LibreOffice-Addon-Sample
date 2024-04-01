#include "Toolbar.hxx"

#include <com/sun/star/awt/DialogProvider.hpp>
#include <com/sun/star/awt/XUnoControlDialog.hpp>
#include <com/sun/star/frame/XFrame.hpp>

#include <thread>



Toolbar::Toolbar(const css::uno::Reference<css::uno::XComponentContext>& context, css::uno::Reference<css::frame::XFrame>& frame):
                context_(context), frame_(frame) {}


void SAL_CALL Toolbar::dispatch(const css::util::URL& url, const css::uno::Sequence<css::beans::PropertyValue>& args) {
    if (url.Path == "RadioButton1Cmd") {
        auto dialogProvider = css::awt::DialogProvider::createWithModel(context_, frame_->getController()->getModel());
        auto dialogInterface = dialogProvider->createDialog("vnd.sun.star.extension://org.apache.openoffice.framework.SimpleAddon/MyDialog.xdl");
        auto dialog = css::uno::Reference<css::awt::XUnoControlDialog> {dialogInterface, css::uno::UNO_QUERY_THROW};
        dialog->execute();
    }
}


void SAL_CALL Toolbar::addStatusListener(const css::uno::Reference<css::frame::XStatusListener>& control, const css::util::URL& url) {}
void SAL_CALL Toolbar::removeStatusListener(const css::uno::Reference<css::frame::XStatusListener>& control, const css::util::URL& url) {}