#pragma once 

#include <com/sun/star/frame/XDispatchProvider.hpp>
#include <com/sun/star/lang/XInitialization.hpp>
#include <cppuhelper/implbase2.hxx>

namespace com::sun::star {
    namespace frame {
        class XFramesSupplier;
        class XDispatch;
    }

    namespace uno {
        class XComponentContext;
    }
}

class DispatchProvider final: public cppu::WeakImplHelper2<css::frame::XDispatchProvider, css::lang::XInitialization>
{
private:
    css::uno::Reference<css::uno::XComponentContext> context_;
    css::uno::Reference<css::frame::XDispatch> dispatch_;
    css::uno::Reference<css::frame::XFramesSupplier> framesSupplier_;

public:
    explicit DispatchProvider(const css::uno::Reference<css::uno::XComponentContext>& rxContext);

    // XDispatchProvider
    css::uno::Reference<css::frame::XDispatch> SAL_CALL queryDispatch(const css::util::URL& aURL, const rtl::OUString& sTargetFrameName,
                                                                        sal_Int32 nSearchFlags) final;
    css::uno::Sequence<css::uno::Reference<css::frame::XDispatch>>
            SAL_CALL queryDispatches(const css::uno::Sequence<css::frame::DispatchDescriptor>& seqDescriptor) final;

    // XInitialization
    void SAL_CALL initialize(const css::uno::Sequence<css::uno::Any>& aArguments) final;

    // XServiceInfo manual implementation
    static rtl::OUString SAL_CALL getImplementationName();
    static css::uno::Sequence<rtl::OUString> SAL_CALL getSupportedServiceNames();
};