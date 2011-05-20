/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Written (W) 2010 Koen van de Sande
 * Copyright (C) 2010 Koen van de Sande / University of Amsterdam
 */

#include "lib/common.h"
#include "kernel/HistogramIntersectionKernel.h"
#include "features/Features.h"
#include "features/SimpleFeatures.h"
#include "lib/io.h"

using namespace shogun;

CHistogramIntersectionKernel::CHistogramIntersectionKernel(void)
: CDotKernel(0)
{
	SG_UNSTABLE("CHistogramIntersectionKernel::"
				"CHistogramIntersectionKernel(void)", "\n");
}

CHistogramIntersectionKernel::CHistogramIntersectionKernel(int32_t size)
: CDotKernel(size)
{
}

CHistogramIntersectionKernel::CHistogramIntersectionKernel(
	CSimpleFeatures<float64_t>* l, CSimpleFeatures<float64_t>* r, int32_t size)
: CDotKernel(size)
{
	init(l,r);
}

CHistogramIntersectionKernel::~CHistogramIntersectionKernel()
{
	cleanup();
}

bool CHistogramIntersectionKernel::init(CFeatures* l, CFeatures* r)
{
	bool result=CDotKernel::init(l,r);
	init_normalizer();
	return result;
}

float64_t CHistogramIntersectionKernel::compute(int32_t idx_a, int32_t idx_b)
{
	int32_t alen, blen;
	bool afree, bfree;

	float64_t* avec=
		((CSimpleFeatures<float64_t>*) lhs)->get_feature_vector(idx_a, alen, afree);
	float64_t* bvec=
		((CSimpleFeatures<float64_t>*) rhs)->get_feature_vector(idx_b, blen, bfree);
	ASSERT(alen==blen);

	float64_t result=0;
	for (int32_t i=0; i<alen; i++)
		result += (avec[i] < bvec[i]) ? avec[i] : bvec[i];

	((CSimpleFeatures<float64_t>*) lhs)->free_feature_vector(avec, idx_a, afree);
	((CSimpleFeatures<float64_t>*) rhs)->free_feature_vector(bvec, idx_b, bfree);

	return result;
}
