#include "DispatchProvider.hxx"
#include "Toolbar.hxx"

#include <com/sun/star/frame/XFrame.hpp>

#include <array>

DispatchProvider::DispatchProvider(const css::uno::Reference<css::uno::XComponentContext>& rxContext) : context_(rxContext) {}

void SAL_CALL DispatchProvider::initialize(const css::uno::Sequence<css::uno::Any>& aArguments) {
    css::uno::Reference<css::frame::XFrame> xFrame;
    aArguments[0] >>= xFrame;
    if (not framesSupplier_.is()) framesSupplier_ = xFrame->getCreator();
}

css::uno::Reference<css::frame::XDispatch> SAL_CALL DispatchProvider::queryDispatch(const css::util::URL& aURL, const rtl::OUString& sTargetFrameName, sal_Int32 nSearchFlags) { 
    if (not dispatch_.is()) {

        auto frame = framesSupplier_->getActiveFrame();
        dispatch_ = new Toolbar(context_, frame);
    }
    return dispatch_;
}

css::uno::Sequence<css::uno::Reference<css::frame::XDispatch>>
            SAL_CALL DispatchProvider::queryDispatches(const css::uno::Sequence<css::frame::DispatchDescriptor>& seqDescriptor) { return {}; }

rtl::OUString SAL_CALL DispatchProvider::getImplementationName() { return "cybersecurity.irm.libreoffice.addon.comp.framework.ProtocolHandler.impl";}

css::uno::Sequence<rtl::OUString> SAL_CALL DispatchProvider::getSupportedServiceNames() {
    const std::array<rtl::OUString, 1> names {"com.sun.star.frame.Protocol123"};
    return {names.data(), names.size()};

}