#pragma once

#include <com/sun/star/frame/XDispatch.hpp>
#include <cppuhelper/implbase1.hxx>

namespace com::sun::star {
    namespace frame {
        class XFrame;
    }

    namespace uno {
        class XComponentContext;
    }
}

class Toolbar final: public cppu::WeakImplHelper1<css::frame::XDispatch>
{
private:
    css::uno::Reference<css::uno::XComponentContext> context_;
    css::uno::Reference<css::frame::XFrame> frame_;

public:
    Toolbar(const css::uno::Reference<css::uno::XComponentContext>& context, css::uno::Reference<css::frame::XFrame>& frame);

    // XDispatch
    void SAL_CALL dispatch(const css::util::URL& url, const css::uno::Sequence<css::beans::PropertyValue>& args) final;
    void SAL_CALL addStatusListener(const css::uno::Reference<css::frame::XStatusListener>& control, const css::util::URL& url) final;
    void SAL_CALL removeStatusListener(const css::uno::Reference<css::frame::XStatusListener>& control, const css::util::URL& url) final;

};