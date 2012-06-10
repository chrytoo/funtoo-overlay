# Copyright 1999-2012 Gentoo Foundation, 2012 Funtoo Technologies
# Distributed under the terms of the GNU General Public License v2

EAPI=4-python
PYTHON_MULTIPLE_ABIS=1
PYTHON_RESTRICTED_ABIS="3.* *-jython *-pypy-*"

inherit distutils eutils

DESCRIPTION="Salt is a remote execution and configuration manager."
HOMEPAGE="http://saltstack.org/"
SRC_URI="mirror://github/saltstack/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="+jinja libvirt mongodb mysql redis"

DEPEND=""
RDEPEND="${DEPEND}
		>=dev-python/pyzmq-2.1.9 $(python_abi_depend dev-python/pyyaml) dev-python/msgpack
		$(python_abi_depend dev-python/m2crypto dev-python/pycrypto)
		jinja? ( $(python_abi_depend dev-python/jinja ) )
		libvirt? ( app-emulation/libvirt[python] )
		mongodb? ( $(python_abi_depend dev-python/pymongo ) )
		mysql? ( $(python_abi_depend dev-python/mysql-python ) )
		redis? ( $(python_abi_depend dev-python/redis-py ) )"

src_install() {
	distutils_src_install
	for s in minion master syndic; do
		newinitd "${FILESDIR}"/${s}-initd-1 salt-${s}
		newconfd "${FILESDIR}"/${s}-confd-1 salt-${s}
	done
	dodoc README.rst AUTHORS
}

python_test() {
	./setup.py test || die
}
